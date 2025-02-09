variable "env" {}
variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "private_subnet_cidr_2" {}
variable "public_subnet_cidr_2" {}
variable "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}
variable "availability_zones" {
  description = "List of AZ"
  type        = list(string)
}