
# Security Group
resource "aws_security_group" "sg" {
  name        = "${var.env}-sg"
  description = "Security group for public ips"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.security_group_rules
    content {
      cidr_blocks = ingress.value.cidr_blocks
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
    }
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  tags = {
    Name = "${var.env}-frontend-sg"
  }
}
