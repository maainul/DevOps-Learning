
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "dev-vpc"
  }
}


resource "aws_subnet" "jenkins_public_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.jenkins_cidr_block
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1c"
  tags = {
    Name = "Jenkins-Public-1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "dev-fast-food-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "dev-fast-food-public-rt"
  }
}

resource "aws_route_table_association" "jenkins_public_1" {
  subnet_id      = aws_subnet.jenkins_public_1.id
  route_table_id = aws_route_table.public_rt.id
}

