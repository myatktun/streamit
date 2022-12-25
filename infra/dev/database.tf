resource "kubernetes_storage_class" "db" {
  metadata {
    name = "db-sc"
  }

  storage_provisioner = "kubernetes.io/no-provisioner"

  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true
}

resource "kubernetes_persistent_volume" "db" {
  metadata {
    name = "db-pv"
    labels = {
      type = "local"
    }
  }

  spec {
    capacity = {
      storage = "2Gi"
    }

    volume_mode                      = "Filesystem"
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = kubernetes_storage_class.db.metadata[0].name
    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "type"
            operator = "In"
            values   = ["general"]
          }
        }
      }
    }

    persistent_volume_source {
      local {
        path = "/mnt/data"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "db" {
  metadata {
    name = "db-pvc"
  }

  spec {
    storage_class_name = kubernetes_storage_class.db.metadata[0].name
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

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
          volume_mount {
            name       = "db-data"
            mount_path = "/data/db"
          }
        }
        volume {
          name = "db-data"
          persistent_volume_claim {
            claim_name = "db-pvc"
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
