resource "aws_security_group" "dev_sg" {
  name        = "terraform_ec2_private_sg"
  description = "Allow limited inbound external traffic"
  vpc_id      = aws_vpc.dev.id
  tags = {
    Name = "terraform_ec2_private_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_22_ipv4" {
  security_group_id = aws_security_group.dev_sg.id
  cidr_ipv4         = aws_vpc.dev.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_8080_ipv4" {
  security_group_id = aws_security_group.dev_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "allow_443_ipv4" {
  security_group_id = aws_security_group.dev_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.dev_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Creating EC2 in Public Subnet
resource "aws_instance" "public_inst_1" {
  ami                         = "ami-0e1bed4f06a3b463d"
  instance_type               = "t2.micro"
  key_name                    = "tera-key"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.dev_sg.id]
  subnet_id                   = aws_subnet.dev-public-1.id
  count                       = 1
  tags = {
    Name = "public_inst_1"
  }
}

# Creating EC2 in Private Subnet
resource "aws_instance" "public_inst_2" {
  ami                         = "ami-0e1bed4f06a3b463d"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.dev_sg.id]
  subnet_id                   = aws_subnet.dev-private-1.id
  key_name                    = "tera-key"
  associate_public_ip_address = false
  count                       = 1
  tags = {
    Name = "private_inst_2"
  }
}