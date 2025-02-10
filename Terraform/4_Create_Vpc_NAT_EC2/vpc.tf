provider "aws" {
  region = "us-east-1"
}

# Creating VPC,name, CIDR and Tags
resource "aws_vpc" "dev-vpc" {
  cidr_block           = "20.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Dev-VPC"
  }
}

# Creating Public Subnets in VPC
resource "aws_subnet" "dev-public" {
  vpc_id                  = aws_vpc.dev-vpc.id
  cidr_block              = "20.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Dev-Public"
  }
}

# Creating Private Subnets in VPC
resource "aws_subnet" "dev-private" {
  vpc_id                  = aws_vpc.dev-vpc.id
  cidr_block              = "20.0.2.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "Dev-Private"
  }
}

# Creating Internet Gateway in AWS VPC
resource "aws_internet_gateway" "dev-gw" {
  vpc_id = aws_vpc.dev-vpc.id
  tags = {
    Name = "Dev-Gateway"
  }
}

# Creating Route Tables for Public Subnets Internet gateway
resource "aws_route_table" "dev-public-rt" {
  vpc_id = aws_vpc.dev-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-gw.id
  }
  tags = {
    Name = "Dev-Public"
  }
}

# Creating Route Associations public subnets
resource "aws_route_table_association" "dev-public" {
  route_table_id = aws_route_table.dev-public-rt.id
  subnet_id      = aws_subnet.dev-public.id
}
