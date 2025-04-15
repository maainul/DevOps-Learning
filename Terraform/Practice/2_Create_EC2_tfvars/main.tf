#EC2 Instance 
resource "aws_instance" "terademo" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet[0].id
  associate_public_ip_address = true
  key_name                    = "${var.env}-terraform-key"
  security_groups             = [aws_security_group.sg.id]
  depends_on                  = [aws_key_pair.generated_key]
  tags = {
    Name        = "${var.env}_tera_test"
    Environment = var.env
  }
}
