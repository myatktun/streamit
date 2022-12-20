variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "app_version" {
  type    = number
  default = 1.0
}

variable "ecr_login" {
  type = string
}

variable "ecr_token" {
  type = string
}
