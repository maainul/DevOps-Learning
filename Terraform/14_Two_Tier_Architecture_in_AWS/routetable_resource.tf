# Create route table to internet gateway
resource "aws_route_table" "project_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "project-rt"
  }
}

# Associate public subnets with route table
resource "aws_route_table_association" "public_route_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.project_rt.id
}

resource "aws_route_table_association" "public_route_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.project_rt.id
}

# Public Security Group for Web Servers and Load Balancer
resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Allow web (HTTP/HTTPS) and SSH traffic"
  vpc_id      = aws_vpc.vpc.id
}

# Allow HTTP traffic on port 80 (web traffic)
resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  security_group_id = aws_security_group.public_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}


# Allow SSH traffic on port 22 (restricted to a specific IP or range)
resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.public_sg.id
  cidr_blocks       = ["0.0.0.0/0"] # Replace with your IP
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

# Allow all outbound traffic
resource "aws_security_group_rule" "public_egress" {
  type              = "egress"
  security_group_id = aws_security_group.public_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

# Private Security Group for Database
resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Allow traffic for database"
  vpc_id      = aws_vpc.vpc.id
}

# Allow MySQL traffic on port 3306 (only from public security group)
resource "aws_security_group_rule" "allow_mysql" {
  type                     = "ingress"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.public_sg.id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
}

# Allow SSH traffic on port 22 (restricted to public security group)
resource "aws_security_group_rule" "allow_ssh_private" {
  type                     = "ingress"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.public_sg.id
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
}

# Allow all outbound traffic
resource "aws_security_group_rule" "private_egress" {
  type              = "egress"
  security_group_id = aws_security_group.private_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

