

terraform/
│── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars
│   ├── staging/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars
│   ├── prod/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars
│── modules/
│   ├── network/
│   ├── compute/
│   ├── database/
│   ├── security/
│── terraform.tfstate
│── backend.tf
│── providers.tf
│── versions.tf


AKIA2YICALNPY6ESAGUZ

S1BOeVB/jTRFpHmN3gJAEL8/jR0ir251q9kPAUTk



resource "aws_instance" "backend" {
  ami             = "ami-0c55b159cbfafe1f0" # Update with a valid AMI
  instance_type   = "t2.micro"
  subnet_id       = module.network.private_subnet_id
  security_groups = [module.network.backend_sg_id]
  key_name        = "fast-food"

  # user_data = <<-EOF
  #             #!/bin/bash
  #             sudo apt update -y
  #             sudo apt install -y docker.io
  #             sudo systemctl start docker
  #             sudo systemctl enable docker
  #             sudo docker run -d -p 3000:3000 my-backend-app
  #             EOF

  tags = {
    Name = "${var.env}-backend-instance"
  }
}

resource "aws_instance" "frontend" {
  ami             = "ami-0c55b159cbfafe1f0" # Update with a valid AMI
  instance_type   = "t2.micro"
  subnet_id       = module.network.public_subnet_id
  security_groups = [module.network.frontend_sg_id]
  key_name        = "fast-food" # Added key for SSH access if needed

  # user_data = <<-EOF
  #             #!/bin/bash
  #             sudo apt update -y
  #             sudo apt install -y docker.io
  #             sudo systemctl start docker
  #             sudo systemctl enable docker
  #             sudo docker run -d -p 80:3000 my-frontend-app
  #             EOF

  tags = {
    Name = "${var.env}-frontend-instance"
  }
}
