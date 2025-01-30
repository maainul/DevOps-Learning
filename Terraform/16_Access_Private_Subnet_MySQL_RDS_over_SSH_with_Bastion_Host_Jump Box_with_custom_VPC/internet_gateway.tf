resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.tutorial_vpc.id
  tags = {
    Name = "my_igw"
  }
}