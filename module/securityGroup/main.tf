resource "aws_security_group" "accessSsh"{
  name = var.nomGroup
  ingress{
    from_port = var.fromPort
    to_port = var.toPort
    protocol = var.protocol
    cidr_blocks = var.cidr
  }
}