output "public_dns" {
  value       = aws_instance.example.public_dns
  description = "This is public DNS for Webapp"
}

output "subnet_id" {
  value       = aws_instance.example.subnet_id
  description = "This is subnet id"
}