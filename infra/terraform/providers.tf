terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project     = "streamit"
      Environment = "dev"
      Type        = "web-app"
    }
  }
}

provider "kubernetes" {
  host                   = aws_eks_cluster.streamit_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.streamit_cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      aws_eks_cluster.streamit_cluster.name
    ]
  }
}
