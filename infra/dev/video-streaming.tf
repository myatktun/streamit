locals {
  service_name = "video-streaming"
  image_tag    = "${aws_ecr_repository.streamit_video-streaming.repository_url}:${var.app_version}"
  dockercreds = {
    auths = {
      "${var.ecr_login}" = {
        auth = data.aws_ecr_authorization_token.name.authorization_token
      }
    }
  }
}

resource "null_resource" "docker_build" {
  depends_on = [
    aws_ecr_repository.streamit_video-streaming
  ]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
    yarn build video-streaming
    docker build -t ${local.image_tag} -f ../../apps/${local.service_name}/Dockerfile.prod ../../.
    EOT
  }
}

resource "null_resource" "docker_login" {
  depends_on = [
    null_resource.docker_build
  ]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${var.ecr_login}"
  }
}

resource "null_resource" "docker_push" {
  depends_on = [
    null_resource.docker_login
  ]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "docker push ${local.image_tag}"
  }
}

resource "kubernetes_secret" "docker_credentials" {
  metadata {
    name = "docker-credentials"
  }

  data = {
    ".dockerconfigjson" = jsonencode(local.dockercreds)
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_config_map" "video-streaming" {
  metadata {
    name = "video-streaming-config"
  }

  data = {
    PORT               = "80"
    VIDEO_STORAGE_HOST = "video-storage"
    VIDEO_STORAGE_PORT = "80"
    DBHOST             = "mongodb://db:27017"
    DBNAME             = "video-streaming"
    RABBITMQ           = "amqp://rabbitmq"
  }
}

resource "kubernetes_deployment" "video-streaming" {
  depends_on = [
    null_resource.docker_push
  ]

  metadata {
    name = local.service_name
    labels = {
      pod = local.service_name
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        pod = local.service_name
      }
    }

    template {
      metadata {
        labels = {
          pod = local.service_name
        }
      }
      spec {
        container {
          name  = local.service_name
          image = local.image_tag
          env {
            name  = "PORT"
            value = "80"
          }
          env_from {
            config_map_ref {
              name = "video-streaming-config"
            }
          }
        }
        image_pull_secrets {
          name = kubernetes_secret.docker_credentials.metadata[0].name
        }
      }
    }
  }
}

resource "kubernetes_service" "video-streaming" {
  metadata {
    name = local.service_name
  }

  spec {
    selector = {
      pod = kubernetes_deployment.video-streaming.metadata[0].labels.pod
    }

    port {
      port = 80
    }

    type = "NodePort"
  }
}
