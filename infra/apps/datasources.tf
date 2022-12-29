data "aws_ecr_authorization_token" "name" {}

data "aws_ecr_repository" "video_streaming" {
  name = "video-streaming"
}

data "aws_ecr_repository" "aws_storage" {
  name = "aws-storage"
}

data "aws_ecr_repository" "view_history" {
  name = "view-history"
}

data "aws_availability_zones" "available" {}

data "aws_eks_cluster" "streamit_cluster" {
  name = "streamit-cluster"
}
