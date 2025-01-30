// Create an EC2 instance named "tutorial_web"
resource "aws_instance" "my_web" {
  count                  = var.settings.web_app.count
  ami                    = "ami-0287a05f0ef0e9d9a"
  instance_type          = var.settings.web_app.instance_type
  subnet_id              = aws_subnet.tutorial_public_subnet[count.index].id
  key_name               = "three-tier"
  vpc_security_group_ids = [aws_security_group.my_web_sg.id]
  tags = {
    Name = "my_web_${count.index}"
  }
}
