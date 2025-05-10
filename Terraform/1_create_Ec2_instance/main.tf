provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "terademo" {
    ami = "ami-0f9de6e2d2f067fca"
    instance_type = "t2.micro"
    key_name = "nodejs-test-pair"
    subnet_id = "subnet-04871572f8266f19a"
    tags = {
      Name="Tera-Test"
    }
}
