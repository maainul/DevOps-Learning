provider "aws" {
  region     = "us-east-1"
  profile    = "default"
  access_key = ""
  secret_key = ""
}

# Dedicated VPC
resource "aws_vpc" "vpc" {
  cidr_block           = lookup(var.vpc_cidr_block, var.env)
  enable_dns_hostnames = true
  tags = {
    Name        = "${local.env}-vpc"
    Environment = local.env
  }
}

# Subnet Block
resource "aws_subnet" "public_subnet" {
  count      = length(lookup(var.public_subnet_cidr_blocks, var.env))
  vpc_id     = aws_vpc.vpc.id
  cidr_block = lookup(var.public_subnet_cidr_blocks, var.env)[count.index]
  tags = {
    Name = "${local.env}-public-subnet-${count.index + 1}"
  }
}

# Create public and private Key
resource "tls_private_key" "terraform_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generate key pair
resource "aws_key_pair" "generated_key" {
  key_name   = "${local.env}-terraform-key"
  public_key = tls_private_key.terraform_key.public_key_openssh
}

# Save File locally in directory
resource "local_file" "private_key" {
  content         = tls_private_key.terraform_key.private_key_pem
  filename        = "${path.module}/${local.env}-terraform-key.pem"
  file_permission = "0600"
}

# Elastic IP Address Allocation for EC2
resource "aws_eip" "ec2_ip" {
  tags = {
    Name = "${local.env}_my_eip_ec2"
  }
}

#Associate IP With Instances
resource "aws_eip_association" "terademo_eip_association" {
  instance_id   = aws_instance.terademo.id
  allocation_id = aws_eip.ec2_ip.id
}

# Security Group
resource "aws_security_group" "sg" {
  name        = "${local.env}-sg"
  description = "Security group for public ips"
  vpc_id      = aws_vpc.vpc.id
}

# Ingress Rules
resource "aws_security_group_rule" "allow_80" {
  security_group_id = aws_security_group.sg.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}

resource "aws_security_group_rule" "allow_22" {
  security_group_id = aws_security_group.sg.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

resource "aws_security_group_rule" "allow_3000" {
  security_group_id = aws_security_group.sg.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
}

#Egress Rules
resource "aws_security_group_rule" "allow_all" {
  security_group_id = aws_security_group.sg.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

# Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${local.env}_my_igw"
  }
}

# Route Table
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "${local.env}_rt"
  }
}

# Route Table assocation
resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.pub_rt.id
  subnet_id      = aws_subnet.public_subnet[0].id
}

#EC2 Instance 
resource "aws_instance" "terademo" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet[0].id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.generated_key.key_name
  security_groups             = [aws_security_group.sg.id]
  depends_on                  = [aws_key_pair.generated_key]
  tags = {
    Name        = "${local.env}_tera_test"
    Environment = local.env
  }
  # provisioner "file" {
  #   source      = "D:/Codes/DevOps-Learning/Terraform/Practice/1_Create_EC2/README.md"
  #   destination = "/home/ubuntu/README.md"
  # }
  # connection {
  #   type        = "ssh"
  #   host        = self.public_ip
  #   user        = "ubuntu"
  #   private_key = tls_private_key.terraform_key.private_key_pem
  #   timeout     = "10m"
  # }
}
