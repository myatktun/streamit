resource "aws_security_group" "node_group" {
  name_prefix = "node-group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["10.0.0.0/8"]
  }
}
