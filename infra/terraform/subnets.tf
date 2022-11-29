resource "aws_subnet" "streamit_public_1" {
  vpc_id                  = aws_vpc.streamit_vpc.id
  cidr_block              = "10.0.0.0/20"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = merge(
    var.default_tags,
    {
      Name                                       = "${var.project_name}-public-ap-southeast-1a"
      "kubernetes.io/cluster/${var.eks_cluster}" = "shared"
      "kubernetes.io/role/elb"                   = 1
    }
  )
}

resource "aws_subnet" "streamit_public_2" {
  vpc_id                  = aws_vpc.streamit_vpc.id
  cidr_block              = "10.0.16.0/20"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true

  tags = merge(
    var.default_tags,
    {
      Name                                       = "${var.project_name}-public-ap-southeast-1b"
      "kubernetes.io/cluster/${var.eks_cluster}" = "shared"
      "kubernetes.io/role/elb"                   = 1
    }
  )
}

resource "aws_subnet" "streamit_private_1" {
  vpc_id            = aws_vpc.streamit_vpc.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "ap-southeast-1a"

  tags = merge(
    var.default_tags,
    {
      Name                                       = "${var.project_name}-private-ap-southeast-1a"
      "kubernetes.io/cluster/${var.eks_cluster}" = "shared"
      "kubernetes.io/role/internal-elb"          = 1
    }
  )
}

resource "aws_subnet" "streamit_private_2" {
  vpc_id            = aws_vpc.streamit_vpc.id
  cidr_block        = "10.0.48.0/20"
  availability_zone = "ap-southeast-1b"

  tags = merge(
    var.default_tags,
    {
      Name                                       = "${var.project_name}-private-ap-southeast-1b"
      "kubernetes.io/cluster/${var.eks_cluster}" = "shared"
      "kubernetes.io/role/internal-elb"          = 1
    }
  )
}
