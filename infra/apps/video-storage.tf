locals {
  service_name_video_storage = "video-storage"
  image_tag_video_storage    = "${data.aws_ecr_repository.aws_storage.repository_url}:latest"
}

resource "kubernetes_config_map" "video-storage" {
  metadata {
    name = "video-storage-config"
  }

  data = {
    PORT                  = "80"
    S3_REGION             = var.region
    S3_BUCKET             = "streamitaws"
    AWS_ACCESS_KEY_ID     = var.aws_access_key_id
    AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
  }
}

resource "kubernetes_deployment" "video-storage" {
  metadata {
    name = local.service_name_video_storage
    labels = {
      pod = local.service_name_video_storage
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        pod = local.service_name_video_storage
      }
    }

    template {
      metadata {
        labels = {
          pod = local.service_name_video_storage
        }
      }
      spec {
        container {
          name  = local.service_name_video_storage
          image = local.image_tag_video_storage
          env_from {
            config_map_ref {
              name = "video-storage-config"
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

resource "kubernetes_service" "video-storage" {
  metadata {
    name = local.service_name_video_storage
  }

  spec {
    selector = {
      pod = kubernetes_deployment.video-storage.metadata[0].labels.pod
    }

    port {
      port = 80
    }
  }
}
