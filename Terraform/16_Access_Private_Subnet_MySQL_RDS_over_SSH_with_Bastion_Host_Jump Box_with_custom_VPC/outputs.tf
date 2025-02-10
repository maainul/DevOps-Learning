// This will output the public IP of the web server
output "web_public_ip" {
  description = "The public IP address of the web server"
  value       = aws_eip.my_web_eip[0].public_ip
  depends_on = [aws_eip.my_web_eip]
}

// This will output the the public DNS address of the web server
output "web_public_dns" {
  description = "The public DNS address of the web server"
  value       = aws_eip.my_web_eip[0].public_dns
  depends_on = [aws_eip.my_web_eip]
}

// This will output the database endpoint
output "database_endpoint" {
  description = "The endpoint of the database"
  value       = aws_db_instance.my_database.address
}

// This will output the database port
output "database_port" {
  description = "The port of the database"
  value       = aws_db_instance.my_database.port
}