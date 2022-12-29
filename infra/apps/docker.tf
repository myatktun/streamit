locals {
  dockercreds = {
    auths = {
      "${var.ecr_tag}" = {
        auth = data.aws_ecr_authorization_token.name.authorization_token
      }
    }
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
