output "public_ip_address" {
  value = aws_instance.terademo.public_ip
}

output "private_key_location" {
  value = local_file.private_key.filename
}
