env                       = "prod"
aws_region                = "us-east-1"
aws_profile               = "default"
ami                       = "ami-04b4f1a9cf54c11d0"
instance_type             = "t2.micro"
vpc_cidr_block            = "10.2.0.0/16"
public_subnet_cidr_blocks = ["10.2.1.0/24"]
security_group_rules = [
  { cidr_blocks = ["0.0.0.0/0"], from_port = 80, to_port = 80, protocol = "tcp" },
  { cidr_blocks = ["0.0.0.0/0"], from_port = 22, to_port = 22, protocol = "tcp" },
  { cidr_blocks = ["0.0.0.0/0"], from_port = 3000, to_port = 3000, protocol = "tcp" }
]