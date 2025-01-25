provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "dev_vpc" {
  cidr_block           = "20.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "dev-public" {
  vpc_id                 = aws_vpc.dev-vpc.vpc_id
  cidr_block             = "20.0.1.0/24"
  availability_zone      = "us-east-1a"
  map_public_ip_on_lunch = true
  tags = {
    Name = "Dev-Public"
  }
}