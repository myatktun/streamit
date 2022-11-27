resource "aws_ecr_repository" "streamit_aws-storage" {
  name                 = "aws-storage"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "streamit"
    Environment = "dev"
    Type        = "web-app"
    Name        = "aws-storage"
  }
}

resource "aws_ecr_repository" "streamit_video-streaming" {
  name                 = "video-streaming"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "streamit"
    Environment = "dev"
    Type        = "web-app"
    Name        = "video-streaming"
  }
}

resource "aws_ecr_repository" "streamit_view-history" {
  name                 = "view-history"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "streamit"
    Environment = "dev"
    Type        = "web-app"
    Name        = "view-history"
  }
}
