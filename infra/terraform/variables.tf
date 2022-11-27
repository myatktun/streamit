variable "region" {
  default = "ap-southeast-1"
}

variable "project_name" {
  default = "streamit"
}

variable "project_type" {
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
