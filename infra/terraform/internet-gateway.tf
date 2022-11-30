resource "aws_internet_gateway" "streamit_igw" {
  vpc_id = aws_vpc.streamit_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}
