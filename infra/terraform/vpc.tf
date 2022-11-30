resource "aws_vpc" "streamit_vpc" {
  cidr_block                       = "10.0.0.0/18"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "${var.project_name}-vpc"
  }
}
