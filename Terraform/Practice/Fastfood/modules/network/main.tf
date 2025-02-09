# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.env}-vpc"
  }
}

# Internet Gateway for public access (for frontend)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

# Public Subnet (For Frontend)
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-public-subnet"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_2
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-public-subnet-2"
  }
}

# Private Subnet (For Backend)
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a" # Change to a different AZ
  tags = {
    Name = "${var.env}-private-subnet"
  }
}

# Additional Private Subnet (For Database, AZ-2)
resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr_2
  availability_zone       = "us-east-1b" # Change to a different AZ
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-private-subnet-2"
  }
}

# NAT Gateway (Allows backend to access the internet)
resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.igw] # Ensure IGW exists before assigning the Elastic IP
  tags       = { Name = "${var.env}-nat-eip-1" }
}

resource "aws_eip" "nat_eip_2" {
  depends_on = [aws_internet_gateway.igw]
  tags       = { Name = "${var.env}-nat-eip-2" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id                 # Must be same AZ as private backend
  depends_on    = [aws_internet_gateway.igw, aws_eip.nat_eip] # Ensures order
  tags = {
    Name = "${var.env}-nat-gateway"
  }
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id               # Place it in us-east-1b
  depends_on    = [aws_internet_gateway.igw, aws_eip.nat_eip] # Ensures order
  tags = {
    Name = "${var.env}-nat-gateway-2"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-public-rt"
  }
}

# Route Table for Private Subnet (Backend can reach the internet via NAT)
resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id # Uses NAT in us-east-1a
  }

  tags = {
    Name = "${var.env}-private-rt-1"
  }
}

resource "aws_route_table" "private_rt_2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_2.id # Uses NAT in us-east-1b
  }

  tags = {
    Name = "${var.env}-private-rt-2"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private_subnet.id # us-east-1a
  route_table_id = aws_route_table.private_rt_1.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id # us-east-1b
  route_table_id = aws_route_table.private_rt_2.id
}

# Security Group for Frontend (Public)
resource "aws_security_group" "frontend_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { # ✅ Add this to allow outbound traffic
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-frontend-sg"
  }
}

# Security Group for Backend (Private: Database)
resource "aws_security_group" "backend_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id] # Allow access only from Frontend SG
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-backend-sg"
  }
}

# Security Group for Backend (Private: Database)
resource "aws_security_group" "database_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 5432 # PostgreSQL default port
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id] # Allow access from backend SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }

  tags = {
    Name = "${var.env}-database-sg"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index] # ✅ Corrected
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.env}-private-subnet-${count.index + 1}"
  }
}
