resource "aws_route_table" "streamit_public" {
  vpc_id = aws_vpc.streamit_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.streamit_igw.id
  }

  tags = merge(
    var.default_tags,
    {
      Name = "${var.project_name}-public-rt"
    }
  )
}

resource "aws_route_table" "streamit_private_1" {
  vpc_id = aws_vpc.streamit_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.streamit_nat1.id
  }

  tags = merge(
    var.default_tags,
    {
      Name = "${var.project_name}-private-rt1"
    }
  )
}

resource "aws_route_table" "streamit_private_2" {
  vpc_id = aws_vpc.streamit_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.streamit_nat2.id
  }

  tags = merge(
    var.default_tags,
    {
      Name = "${var.project_name}-private-rt2"
    }
  )
}

resource "aws_route_table_association" "streamit_public_1" {
  subnet_id      = aws_subnet.streamit_public_1.id
  route_table_id = aws_route_table.streamit_public.id
}

resource "aws_route_table_association" "streamit_public_2" {
  subnet_id      = aws_subnet.streamit_public_2.id
  route_table_id = aws_route_table.streamit_public.id
}

resource "aws_route_table_association" "streamit_private_1" {
  subnet_id      = aws_subnet.streamit_private_1.id
  route_table_id = aws_route_table.streamit_private_1.id
}

resource "aws_route_table_association" "streamit_private_2" {
  subnet_id      = aws_subnet.streamit_private_2.id
  route_table_id = aws_route_table.streamit_private_2.id
}
