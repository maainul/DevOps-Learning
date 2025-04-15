terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Dedicated VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block[var.env]
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.env}-vpc"
    Environment = var.env
  }
}

# Subnet Block
resource "aws_subnet" "public_subnet" {
  count      = length(var.public_subnet_cidr_blocks[var.env])
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr_blocks[var.env][count.index]
  tags = {
    Name = "${var.env}-public-subnet-${count.index + 1}"
  }
}

# Create Public and Private Key
resource "tls_private_key" "terraform_key" {
  algorithm = "RSA"
  rsa_bits  = 2048 # AWS supports up to 2048 bits only
}


# Generate key pair
resource "aws_key_pair" "generated_key" {
  key_name   = "my-test-key"
  public_key = tls_private_key.terraform_key.public_key_openssh # This ensures the key is in OpenSSH format
}

# Save File to the local directory
resource "local_file" "private_key" {
  content         = tls_private_key.terraform_key.private_key_pem
  filename        = "${path.module}/my-test-key.pem"
  file_permission = "0600"
}

# Elastic IP Address for Ec2
resource "aws_eip" "ec2_ip" {
  tags = {
    Name = "${var.env}-my-eip-ec2"
  }
}

# Associate IP with Instance
resource "aws_eip_association" "ip_association" {
  instance_id   = aws_instance.instance.id
  allocation_id = aws_eip.ec2_ip.id
}

# Security Group 
resource "aws_security_group" "sg" {
  name        = "${var.env}-sg"
  description = "Security Group for Ips"
  vpc_id      = aws_vpc.vpc.id


  # ingress (Inbound Rules)
  dynamic "ingress" {
    for_each = var.security_groups
    content {
      cidr_blocks = ingress.value.cidr_blocks
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.env}-web-sg"
    Environment = "${var.env}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-my-igw"
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
    Name = "${var.env}-my_igw"
  }
}

# Route Table Assocaiation
resource "aws_route_table_association" "rt_a" {
  route_table_id = aws_route_table.pub_rt.id
  subnet_id      = aws_subnet.public_subnet[0].id
}

# EC2 Instance 
resource "aws_instance" "instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet[0].id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.generated_key.key_name
  security_groups             = [aws_security_group.sg.id]
  depends_on                  = [aws_key_pair.generated_key]
  tags = {
    Name        = "${var.env}-test-ec2"
    Environment = "${var.env}"
  }
}
