provider "aws" {
    region = "us-east-1"
}
resource "aws_instance" "terademo" {
    ami = "ami-0e1bed4f06a3b463d"
    instance_type = "t2.micro"
    key_name = "tera-key"
    tags = {
      Name="Tera-Test"
    }
  
}