// Create a VPC named "my_vpc"
resource "aws_vpc" "my_vpc" {
  // Here we are setting the CIDR block of the VPC
  // to the "vpc_cidr_block" variable
  cidr_block           = var.vpc_cidr_block
  // We want DNS hostnames enabled for this VPC
  enable_dns_hostnames = true
  tags = {
    Name = "my_vpc"
  }
}