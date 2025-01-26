provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

#create a security group for RDS Database Instance
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "This is Security Group"
  tags = {
    Name = "rds_sg"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_3306" {
  security_group_id = aws_instance.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tpc"
  from_port         = 3306
  to_port           = 3306
}

resource "aws_vpc_security_group_engress_rule" "allow_all_traffic" {
  security_group_id = aws_instance.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}



#create a RDS Database Instance
resource "aws_db_instance" "myinstance" {
  engine                 = "mysql"
  identifier             = "myrdsinstance"
  allocated_storage      = 20
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username               = "admin"
  password               = "admin12345"
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = true
}