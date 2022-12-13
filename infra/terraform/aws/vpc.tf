module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = "${var.project_name}-vpc"

  cidr = "10.0.0.0/18"
  azs  = slice(data.aws_availability_zones.available.names, 0, 2)

  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks

  enable_nat_gateway              = true
  single_nat_gateway              = true
  enable_dns_hostnames            = true
  assign_ipv6_address_on_creation = false

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster}" = "shared"
    "kubernetes.io/role/elb"                   = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster}" = "shared"
    "kubernetes.io/role/internal-elb"          = 1
  }

  tags = {
    Name = "${var.project_name}-vpc"
  }
}
