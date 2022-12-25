locals {
  service_name_video_storage = "video-storage"
  image_tag_video_storage    = "${aws_ecr_repository.streamit_aws-storage.repository_url}:${var.app_version}"
}

resource "null_resource" "docker_build_aws_storage" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
    yarn build video-storage
    docker build -t ${local.image_tag_video_storage} -f ../../apps/aws-storage/Dockerfile.prod ../../.
    EOT
  }
}

resource "null_resource" "docker_push_aws_storage" {
  depends_on = [
    aws_ecr_repository.streamit_aws-storage,
    null_resource.docker_login,
    null_resource.docker_build_aws_storage
  ]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "docker push ${local.image_tag_video_storage}"
  }
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
  depends_on = [
    null_resource.docker_push_aws_storage
  ]

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

    type = "NodePort"
  }
}
