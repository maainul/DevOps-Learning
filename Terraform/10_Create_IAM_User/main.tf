provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "iam" {
  name = "kusum"
  tags = {
    Name = "Kusum-Demo-User"
  }
}


resource "aws_instance" "dev_instance" {
  ami           = "ami-0e1bed4f06a3b463d"
  instance_type = "t2.micro"
  count         = 1
  tags = {
    Name = "Dev_Instance"
  }
}