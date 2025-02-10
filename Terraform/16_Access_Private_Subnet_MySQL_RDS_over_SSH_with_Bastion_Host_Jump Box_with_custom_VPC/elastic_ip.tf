// Create an Elastic IP named "my_web_eip" for each
// EC2 instance
resource "aws_eip" "my_web_eip" {
  count    = var.settings.web_app.count
  instance = aws_instance.my_web[count.index].id
  tags = {
    Name = "my_web_eip_${count.index}"
  }
}