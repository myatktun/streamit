locals {
  service_name_view_history = "view-history"
  image_tag_view_history    = "${aws_ecr_repository.streamit_view-history.repository_url}:${var.app_version}"
}

resource "null_resource" "docker_build_view_history" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
    yarn build view-history
    docker build -t ${local.image_tag_view_history} -f ../../apps/${local.service_name_view_history}/Dockerfile.prod ../../.
    EOT
  }
}

resource "null_resource" "docker_push_view_history" {
  depends_on = [
    aws_ecr_repository.streamit_view-history,
    null_resource.docker_login,
    null_resource.docker_build_view_history
  ]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "docker push ${local.image_tag_view_history}"
  }
}

resource "kubernetes_config_map" "view-history" {
  metadata {
    name = "view-history-config"
  }

  data = {
    PORT     = "80"
    DBHOST   = "mongodb://db:27017"
    DBNAME   = "view-history"
    RABBITMQ = "amqp://rabbitmq"
  }
}

resource "kubernetes_deployment" "view-history" {
  depends_on = [
    null_resource.docker_push_view_history
  ]

  metadata {
    name = local.service_name_view_history
    labels = {
      pod = local.service_name_view_history
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        pod = local.service_name_view_history
      }
    }

    template {
      metadata {
        labels = {
          pod = local.service_name_view_history
        }
      }
      spec {
        container {
          name  = local.service_name_view_history
          image = local.image_tag_view_history
          env_from {
            config_map_ref {
              name = "view-history-config"
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

resource "kubernetes_service" "view-history" {
  metadata {
    name = local.service_name_view_history
  }

  spec {
    selector = {
      pod = kubernetes_deployment.view-history.metadata[0].labels.pod
    }

    port {
      port = 80
    }

    type = "NodePort"
  }
}
