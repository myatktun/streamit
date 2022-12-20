resource "aws_ecr_repository" "streamit_video-streaming" {
  name                 = "video-streaming"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true

  tags = {
    Name = "video-streaming"
  }
}

locals {
  service   = "video-streaming"
  image_tag = "${aws_ecr_repository.streamit_video-streaming.repository_url}:${var.app_version}"
  dockercreds = {
    auths = {
      "${var.ecr_login}" = {
        auth = var.ecr_token
      }
    }
  }
}

resource "null_resource" "docker_build" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = <<-EOT
    yarn build video-streaming
    docker build -t ${local.image_tag} -f ../../../apps/${local.service}/Dockerfile.prod ../../../.
    EOT
  }
}

resource "null_resource" "docker_login" {
  depends_on = [
    null_resource.docker_build
  ]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${var.ecr_login}"
  }
}

resource "null_resource" "docker_push" {
  depends_on = [
    null_resource.docker_login
  ]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "docker push ${local.image_tag}"
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

resource "kubernetes_pod" "video-streaming" {
  depends_on = [
    null_resource.docker_push
  ]
  metadata {
    name = "video-streaming"
  }

  spec {
    image_pull_secrets {
      name = kubernetes_secret.docker_credentials.metadata[0].name
    }
    container {
      name  = "video-streaming"
      image = local.image_tag
    }
  }
}
