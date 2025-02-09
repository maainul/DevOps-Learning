

resource "aws_instance" "backend" {
  ami             = "ami-0e1bed4f06a3b463d" # Update with a valid AMI
  instance_type   = "t2.micro"
  subnet_id       = var.private_subnet_id
  security_groups = [var.backend_sg_id]
  key_name        = "fast-food"

  tags = {
    Name = "${var.env}-backend-instance"
  }
}

resource "aws_instance" "frontend" {
  ami             = "ami-0e1bed4f06a3b463d" # Update with a valid AMI
  instance_type   = "t2.micro"
  subnet_id       = var.public_subnet_id
  security_groups = [var.frontend_sg_id]
  key_name        = "fast-food" # Added key for SSH access if needed

  tags = {
    Name = "${var.env}-frontend-instance"
  }
}
