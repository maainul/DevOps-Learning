# Creating Nat Gateway
resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.dev-gw]
  tags = {
    Name = "NAT-Gateway-EIP"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  subnet_id     = aws_subnet.dev-public.id
  allocation_id = aws_eip.nat_eip.id
  tags = {
    Name = "Dev-Nat-GW"
  }
}

# Add routes for VPC
resource "aws_route_table" "dev-private-rt" {
  vpc_id = aws_vpc.dev-vpc.id
  route {
    gateway_id = aws_nat_gateway.nat-gw.id
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name = "Dev-Private-Route"
  }
}

# Creating route associations for private Subnets
resource "aws_route_table_association" "dev-private-a" {
  route_table_id = aws_route_table.dev-private-rt.id
  subnet_id      = aws_subnet.dev-private.id
}
