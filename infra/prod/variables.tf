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

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.16.0/20"]
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets"
  type        = list(string)
  default     = ["10.0.32.0/20", "10.0.48.0/20"]
}

variable "app_version" {
  type    = number
  default = 1.0
}

variable "ecr_login" {
  type = string
}
