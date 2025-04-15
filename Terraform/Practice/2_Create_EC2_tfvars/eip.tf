# Elastic IP Address Allocation for EC2
resource "aws_eip" "ec2_ip" {
  tags = {
    Name = "${var.env}_my_eip_ec2"
  }
}

#Associate IP With Instances
resource "aws_eip_association" "terademo_eip_association" {
  instance_id   = aws_instance.terademo.id
  allocation_id = aws_eip.ec2_ip.id
}
