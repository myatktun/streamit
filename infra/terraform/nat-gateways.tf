resource "aws_nat_gateway" "streamit_nat1" {
  allocation_id = aws_eip.streamit_nat1.id
  subnet_id     = aws_subnet.streamit_public_1.id

  tags = merge(
    var.default_tags,
    {
      Name = "streamit-NAT-1"
    }
  )
}

resource "aws_nat_gateway" "streamit_nat2" {
  allocation_id = aws_eip.streamit_nat2.id
  subnet_id     = aws_subnet.streamit_public_2.id

  tags = merge(
    var.default_tags,
    {
      Name = "streamit-NAT-2"
    }
  )
}
