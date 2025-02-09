output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "private_subnet_2" {
  value = aws_subnet.private_subnet_2
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "backend_sg_id" {
  value = aws_security_group.backend_sg.id
}

output "frontend_sg_id" {
  value = aws_security_group.frontend_sg.id
}

output "database_sg_id" {
  value = aws_security_group.database_sg.id
}
output "private_subnet_ids" {
  value = aws_subnet.private[*].id # ✅ Outputs a list of private subnet IDs
}
