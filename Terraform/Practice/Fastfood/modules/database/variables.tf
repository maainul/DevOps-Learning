variable "env" {}
variable "db_username" {}
variable "db_password" {}
variable "private_subnet_ids" {
  description = "List of private subnet IDs for the database"
  type        = list(string)
}
