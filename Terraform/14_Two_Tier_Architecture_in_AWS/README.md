## Follow ME : https://www.devopshint.com/two-tier-architecture-in-aws-using-terraform/#what-is-aws-two-tier-architecture


Video Link : [https://www.youtube.com/watch?v=1wRprEGvkxM&t=35s]


### Step 1:- Create provider.tf file
### Step 2:- Create network resources.tf file
### Step 3:- Create security resources.tf file
### Step 4:- Create routetable_resource.tf file
### Step 5:- Create ec2-resources.tf file
### Step 6:- Create db-resources.tf file

### My Way

1. VPC Creation :
```tf
# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-project"
  }
}
```
2. Internet Gateway
```tf
# Create internet gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "ig-project"
  }
}
```
3. In The Subnet  I need some public and private IPS (Ec2,DB and ALB)

```tf

# Create 2 public subnets
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-2"
  }
}

# Create 2 private subnets
resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-2"
  }
}

# Database subnet group
resource "aws_db_subnet_group" "db_subnet" {
  name       = "db-subnet"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

```

3. Routing Table

```tf
# Create route table to internet gateway
resource "aws_route_table" "project_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "project-rt"
  }
}


# Associate public subnets with route table
resource "aws_route_table_association" "public_route_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.project_rt.id
}

resource "aws_route_table_association" "public_route_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.project_rt.id
}
```

4. Security Group Needed for Ec2,DB and ALB)

```tf
# Public Security Group for Web Servers and Load Balancer
resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Allow web (HTTP/HTTPS) and SSH traffic"
  vpc_id      = aws_vpc.vpc.id
}

# Allow HTTP traffic on port 80 (web traffic)
resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  security_group_id = aws_security_group.public_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}


# Allow SSH traffic on port 22 (restricted to a specific IP or range)
resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.public_sg.id
  cidr_blocks       = ["0.0.0.0/0"] # Replace with your IP
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

# Allow all outbound traffic
resource "aws_security_group_rule" "public_egress" {
  type              = "egress"
  security_group_id = aws_security_group.public_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

# Private Security Group for Database
resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Allow traffic for database"
  vpc_id      = aws_vpc.vpc.id
}

# Allow MySQL traffic on port 3306 (only from public security group)
resource "aws_security_group_rule" "allow_mysql" {
  type                     = "ingress"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.public_sg.id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
}

# Allow SSH traffic on port 22 (restricted to public security group)
resource "aws_security_group_rule" "allow_ssh_private" {
  type                     = "ingress"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.public_sg.id
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
}

# Allow all outbound traffic
resource "aws_security_group_rule" "private_egress" {
  type              = "egress"
  security_group_id = aws_security_group.private_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}


## Load Balance Group
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security Group for ALB"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_all" {
  security_group_id = aws_instance.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  from_port         = 0
  to_port           = 0
}

resource "aws_vpc_security_group_engress_rule" "allow_all" {
  security_group_id = aws_instance.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  from_port         = 0
  to_port           = 0
}

```

5. DB2 Instance 
```hcl
# Create database instance
resource "aws_db_instance" "project_db" {
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  identifier             = "db-instance"
  db_name                = "project_db"
  username               = "admin"
  password               = "password"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
}
```

6. EC2 Instances :
```hcl
resource "aws_instance" "web1" {
  ami                         = ""
  instance_type               = "t2.micro"
  key_name                    = "my-key"
  availability_zone           = "us-east-1b"
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  subnet_id                   = aws_subnet.public_1.id
  associate_public_ip_address = true
  tags = {
    Name = "web1_instance"
  }
}

resource "aws_instance" "web2" {
  ami                         = ""
  instance_type               = "t2.micro"
  key_name                    = "my-key"
  availability_zone           = "us-east-1b"
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  subnet_id                   = aws_subnet.public_2.id
  associate_public_ip_address = true
  tags = {
    Name = "web2_instance"
  }
}

```

7. Create Load Balancer :
```hcl

# Create ALB
resource "aws_lb" "project_alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

# Create ALB target group
resource "aws_lb_target_group" "project_tg" {
  name       = "project-tg"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_vpc.vpc]
}

# Create target attachments
resource "aws_lb_target_group_attachment" "tag_attach1" {
  target_group_arn = aws_lb_target_group.project_tg.arn
  target_id        = aws_instance.web1.id
  port             = 80

  depends_on = [aws_instance.web1]
}


# Create target attachments
resource "aws_lb_target_group_attachment" "tag_attach2" {
  target_group_arn = aws_lb_target_group.project_tg.arn
  target_id        = aws_instance.web2.id
  port             = 80

  depends_on = [aws_instance.web2]
}

# Create listener
resource "aws_lb_listener" "listener_lb" {
  load_balancer_arn = aws_lb.project_alb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.project_tg.arn
  }

}
```