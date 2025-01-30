// Create a security for the EC2 instances called "my_web_sg"
resource "aws_security_group" "my_web_sg" {
  name        = "my_web_sg"
  description = "Allow web (HTTP/HTTPS) and SSH traffic"
  vpc_id      = aws_vpc.my_vpc.id
}

resource "aws_security_group_rule" "allow_80" {
    type              = "ingress"
    security_group_id = aws_security_group.my_web_sg.id
    cidr_blocks       = ["0.0.0.0/0"]
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
}

resource "aws_security_group_rule" "allow_22" {
    type              = "ingress"
    security_group_id = aws_security_group.my_web_sg.id
    cidr_blocks       = ["0.0.0.0/0"]
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
}

resource "aws_security_group_rule" "allow_22" {
    type              = "egress"
    security_group_id = aws_security_group.my_web_sg.id
    cidr_blocks       = ["0.0.0.0/0"]
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
}


// Create a security group for the RDS instances called "my_db_sg"
resource "aws_security_group" "my_db_sg" {
  name        = "my_db_sg"
  description = "Security group for my databases"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "my_db_sg"
  }
}

# Allow MySQL traffic on port 3306 (only from public security group)
resource "aws_security_group_rule" "allow_mysql" {
  type                     = "ingress"
  security_group_id        = aws_security_group.my_db_sg.id
  source_security_group_id = aws_security_group.my_db_sg.id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
}


// Create a db subnet group named "my_db_subnet_group"
resource "aws_db_subnet_group" "my_db_subnet_group" {
  name        = "my_db_subnet_group"
  description = "DB subnet group for my"
  subnet_ids  = [for subnet in aws_subnet.my_private_subnet : subnet.id]
}