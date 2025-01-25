provider "aws" {
  region = "us-east-1"
}

# Security Groups
resource "aws_security_group" "dev_sg" {
  name        = "terraform_ec2_public_sg"
  description = "Allow limited inbound"
  vpc_id      = aws_vpc.dev_vpc.id
  tags = {
    Name = "terraform_ec2_public_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_22" {
  security_group_id = aws_security_group.dev_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_443" {
  security_group_id = aws_security_group.dev_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_80" {
  security_group_id = aws_security_group.dev_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_8080" {
  security_group_id = aws_security_group.dev_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 8080
  to_port           = 8080
}

resource "aws_vpc_security_group_ingress_rule" "allow_5432" {
  security_group_id = aws_security_group.dev_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 5432
  to_port           = 5432
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.dev_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_instance" "tera_demo" {
  ami                         = "ami-0e1bed4f06a3b463d"
  vpc_security_group_ids      = [aws_security_group.dev_sg.id]
  subnet_id                   = aws_subnet.dev-public.id
  instance_type               = "t2.micro"
  key_name                    = "tera-key"
  associate_public_ip_address = false
  count                       = 1
  tags = {
    Name = "Tera-Test"
  }
}
