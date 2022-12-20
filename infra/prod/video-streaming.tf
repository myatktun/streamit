locals {
  service   = "video-streaming"
  image_tag = "${aws_ecr_repository.streamit_video-streaming.repository_url}:${var.app_version}"
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
