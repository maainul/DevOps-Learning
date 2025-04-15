
# Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}_my_igw"
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
    Name = "${var.env}_rt"
  }
}

# Route Table assocation
resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.pub_rt.id
  subnet_id      = aws_subnet.public_subnet[0].id
}