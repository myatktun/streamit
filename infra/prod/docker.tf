locals {
  dockercreds = {
    auths = {
      "${var.ecr_login}" = {
        auth = data.aws_ecr_authorization_token.name.authorization_token
      }
    }
  }
}

resource "null_resource" "docker_login" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${var.ecr_login}"
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
