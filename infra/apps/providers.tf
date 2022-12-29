terraform {
  cloud {
    organization = "test-area"

    workspaces {
      name = "streamit-prod-k8s"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project     = "streamit"
      Environment = "prod"
      Type        = "web-app"
    }
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.streamit_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.streamit_cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.streamit_cluster.name
    ]
  }
}
