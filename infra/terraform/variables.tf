variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "project_name" {
  type    = string
  default = "streamit"
}

variable "project_type" {
  type    = string
  default = "web-app"
}

variable "default_tags" {
  default = {
    Project     = "streamit"
    Environment = "dev"
    Type        = "web-app"
  }
  type = map(string)
}

variable "eks_cluster" {
  type    = string
  default = "streamit-cluster"
}
