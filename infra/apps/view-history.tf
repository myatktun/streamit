locals {
  service_name_view_history = "view-history"
  image_tag_view_history    = "${data.aws_ecr_repository.view_history.repository_url}:latest"
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
  }
}
