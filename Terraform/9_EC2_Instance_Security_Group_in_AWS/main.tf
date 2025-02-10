provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-east-1"
}

resource "aws_security_group" "web_app" {
  name        = "web_app"
  description = "This is Security Group"
  tags = {
    Name = "web_app"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_22" {
  security_group_id = aws_instance.webapp_instance.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tpc"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_8080" {
  security_group_id = aws_instance.webapp_instance.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tpc"
  from_port         = 8080
  to_port           = 8080
}

resource "aws_vpc_security_group_ingress_rule" "allow_443" {
  security_group_id = aws_instance.webapp_instance.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tpc"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_engress_rule" "allow_all_traffic" {
  security_group_id = aws_instance.webapp_instance.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "webapp_instance" {
  ami             = ""
  instance_type   = var.instance_type
  security_groups = ["web_app"]
  key_name        = var.key_name
  tags = {
    Name = "Webapp_Instance"
  }
}
