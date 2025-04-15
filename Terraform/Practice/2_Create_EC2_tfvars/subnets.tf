
# Subnet Block
resource "aws_subnet" "public_subnet" {
  count      = length(var.public_subnet_cidr_blocks)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr_blocks[count.index]
  tags = {
    Name = "${var.env}-public-subnet-${count.index + 1}"
  }
}
