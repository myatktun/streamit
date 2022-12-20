resource "aws_ecr_repository" "streamit_aws-storage" {
  name                 = "aws-storage"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true

  tags = {
    Name = "aws-storage"
  }
}

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

resource "aws_ecr_repository" "streamit_view-history" {
  name                 = "view-history"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true

  tags = {
    Name = "view-history"
  }
}
