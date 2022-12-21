resource "kubernetes_deployment" "rabbitmq" {
  metadata {
    name = "rabbitmq"
    labels = {
      pod = "rabbitmq"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        pod = "rabbitmq"
      }
    }

    template {
      metadata {
        labels = {
          pod = "rabbitmq"
        }
      }

      spec {
        container {
          image = "rabbitmq:3.11-management"
          name  = "rabbitmq"
          port {
            container_port = 5672
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "rabbitmq" {
  metadata {
    name = "rabbitmq"
  }

  spec {
    selector = {
      pod = kubernetes_deployment.rabbitmq.metadata[0].labels.pod
    }

    port {
      port = 5672
    }
  }
}

/* resource "kubernetes_service" "rabbit_dashboard" { */
/*   metadata { */
/*     name = "rabbitmq-dashboard" */
/*   } */

/*   spec { */
/*     selector = { */
/*       pod = kubernetes_deployment.rabbitmq.metadata[0].labels.pod */
/*     } */

/*     port { */
/*       port = 15672 */
/*     } */
/*   } */
/* } */
