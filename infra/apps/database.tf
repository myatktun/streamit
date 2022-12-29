resource "kubernetes_deployment" "db" {
  metadata {
    name = "db"

    labels = {
      pod = "db"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        pod = "db"
      }
    }

    template {
      metadata {
        labels = {
          pod = "db"
        }
      }

      spec {
        container {
          image = "mongo:latest"
          name  = "db"
          port {
            container_port = 27017
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "db" {
  metadata {
    name = "db"
  }

  spec {
    selector = {
      pod = kubernetes_deployment.db.metadata[0].labels.pod
    }

    port {
      port = 27017
    }
  }
}
