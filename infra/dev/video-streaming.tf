locals {
  service_name_video_streaming = "video-streaming"
  image_tag_video_streaming    = "${aws_ecr_repository.streamit_video-streaming.repository_url}:${var.app_version}"
}

resource "null_resource" "docker_build_video_streaming" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
    yarn build video-streaming
    docker build -t ${local.image_tag_video_streaming} -f ../../apps/${local.service_name_video_streaming}/Dockerfile.prod ../../.
    EOT
  }
}

resource "null_resource" "docker_push_video_streaming" {
  depends_on = [
    aws_ecr_repository.streamit_video-streaming,
    null_resource.docker_login,
    null_resource.docker_build_video_streaming
  ]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "docker push ${local.image_tag_video_streaming}"
  }
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
    null_resource.docker_push_video_streaming
  ]

  metadata {
    name = local.service_name_video_streaming
    labels = {
      pod = local.service_name_video_streaming
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        pod = local.service_name_video_streaming
      }
    }

    template {
      metadata {
        labels = {
          pod = local.service_name_video_streaming
        }
      }
      spec {
        container {
          name  = local.service_name_video_streaming
          image = local.image_tag_video_streaming
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
    name = local.service_name_video_streaming
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
