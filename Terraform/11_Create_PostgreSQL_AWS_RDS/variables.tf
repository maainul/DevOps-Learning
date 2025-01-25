variable "region" {
  default     = "us-east-1"
  description = "AWS Region"
}

variable "db_password" {
  description = "RDS root user password"
  sensitive   = true
  default     = "123"
}