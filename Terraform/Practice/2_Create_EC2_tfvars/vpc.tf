# Dedicated VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.env}-vpc"
    Environment = var.env
  }
}