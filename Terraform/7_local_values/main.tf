locals {
  local_setup = "dev"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "dev" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = local.local_setup
  }
}

resource "aws_subnet" "dev-public-1" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = local.local_setup + "-public-1"
  }
}

resource "aws_subnet" "dev-public-2" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"
  tags = {
    Name = local.local_setup + "-public-2"
  }
}

resource "aws_internet_gateway" "dev-gw" {
  vpc_id = aws_vpc.dev.id
  tags = {
    Name = local.local_setup
  }
}

resource "aws_route_table" "dev-public" {
  vpc_id = aws_vpc.dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-gw.id
  }
  tags = {
    Name = local.local_setup + "-public-1"
  }
}

resource "aws_route_table_association" "dev-public-1-a" {
  subnet_id      = aws_subnet.dev-public-1.id
  route_table_id = aws_route_table.dev-public.id
}

resource "aws_route_table_association" "dev-public-2-a" {
  subnet_id      = aws_subnet.dev-public-2.id
  route_table_id = aws_route_table.dev-public.id
}

resource "aws_instance" "public_instance_1" {
  ami           = var.instance_ami
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.dev-public-1.id
  key_name      = var.key_name
  tags = {
    Name = "public_linstance_1"
  }
}

resource "aws_instance" "public_instance_2" {
  ami           = var.instance_ami
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.dev-public-2.id
  key_name      = var.key_name
  tags = {
    Name = "public_linstance_2"
  }
}