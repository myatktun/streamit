resource "aws_eip" "streamit_nat1" {
  depends_on = [aws_internet_gateway.streamit_igw]

  tags = merge(
    var.default_tags,
    {
      Name = "${var.project_name}-EIP-1"
    }
  )
}

resource "aws_eip" "streamit_nat2" {
  depends_on = [aws_internet_gateway.streamit_igw]

  tags = merge(
    var.default_tags,
    {
      Name = "${var.project_name}-EIP-2"
    }
  )
}
