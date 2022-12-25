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

variable "cluster" {
  type    = string
  default = "minikube"
}

variable "app_version" {
  type    = number
  default = 1.0
}

variable "ecr_login" {
  type = string
}

variable "aws_access_key_id" {
  type = string
}

variable "aws_secret_access_key" {
  type = string
}
