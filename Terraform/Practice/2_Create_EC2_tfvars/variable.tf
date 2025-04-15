variable "env" {
  description = "Deployment environment"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "Environment must be dev, staging or prod"
  }
}
variable "aws_region" {
  description = "aws region info"
  type        = string
}
variable "aws_profile" {
  description = "aws profile"
  type        = string
}
variable "ami" {
  description = "Ami Code"
  type        = string
}
variable "instance_type" {
  type        = string
  description = "instance type"
}
variable "vpc_cidr_block" {
  description = "CIDR Block For VPC"
  type        = string
}
variable "public_subnet_cidr_blocks" {
  description = "public subnet cidr blocks"
  type        = list(string)
}
variable "private_subnet_cidr_blocks" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}
variable "allowed_ssh_cidr_blocks" {
  description = "CIDR Blocks allowed for ssh ccess"
  type        = list(string)
}
variable "allowed_http_cidr_blocks" {
  description = "CIDR Blocks allowed for HTTP/HTTPS"
  type        = list(string)
}
variable "allowed_ports" {
  description = "List of allowed ports"
  type        = list(number)
}
variable "security_group_rules" {
  description = "List of ssecurity groups"
  type = list(object({
    cidr_blocks = list(string)
    from_port   = number
    to_port     = number
    protocol    = string
  }))
}
