provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0e1bed4f06a3b463d"
  instance_type = var.instance_type
  count         = var.instance_count

  tags = {
    Name = "Test Instance"
  }
}

resource "aws_iam_user" "terraform_user" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}