resource "aws_internet_gateway" "streamit_igw" {
  vpc_id = aws_vpc.streamit_vpc.id

  tags = merge(
    var.default_tags,
    {
      Name = "streamit-igw"
    }
  )
}
