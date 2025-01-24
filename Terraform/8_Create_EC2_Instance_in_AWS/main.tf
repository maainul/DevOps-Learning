provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-east-1"
}

resource "aws_instance" "Terraform_Demo" {
  ami           = ""
  instance_type = "t2.micro"
  key_name      = "tera-key"
  tags = {
    Name = "Terraform_Demo"
  }
}