provider "aws" {
  region = "us-east-1"
}

# Security Groups for Backend
resource "aws_security_group" "backend_sg" {
  name        = "backend_sg"
  description = "This is Security Group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "dev-fast-food-backend-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "backend_allow_22" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_5000" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 5000
  to_port           = 5000
}

resource "aws_vpc_security_group_ingress_rule" "backend_allow_443" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "backend_engress" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Database Security Group
# Security Groups for Database
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "This is Security Group Database"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "dev-fast-food-db-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "db_allow_22" {
  security_group_id = aws_security_group.db_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_5432" {
  security_group_id = aws_security_group.db_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 5432
  to_port           = 5432
}

resource "aws_vpc_security_group_ingress_rule" "db_allow_443" {
  security_group_id = aws_security_group.db_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "db_engress" {
  security_group_id = aws_security_group.db_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


resource "aws_instance" "jenkins" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.medium"
  key_name               = "fast-food"
  subnet_id              = aws_subnet.jenkins_public_1.id
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  tags = {
    Name = "Jenkins-Master-Instance"
  }
}

