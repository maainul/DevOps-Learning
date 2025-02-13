variable "env" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

locals {
  env = var.env
}

variable "ami" {
  description = "Ami Code"
  type        = string
  default     = "ami-04b4f1a9cf54c11d0"
}

variable "instance_type" {
  description = "instance type"
  type        = string
  default     = "t2.micro"
}

variable "number_of_instance" {
  type    = number
  default = 1
}

variable "vpc_cidr_block" {
  description = "CIDR Block For VPC"
  type        = map(string)

  default = {
    dev     = "10.0.0.0/16"
    staging = "10.1.0.0/16"
    prod    = "10.2.0.0/16"
  }
}

variable "public_subnet_cidr_blocks" {
  description = "public subnet cidr blocks"
  type        = map(list(string))
  default = {
    dev     = ["10.0.1.0/24", "10.0.2.0/24"]
    staging = ["10.1.1.0/24", "10.1.2.0/24"]
    prod    = ["10.2.1.0/24", "10.2.2.0/24"]
  }
}

# private_subnet_cidr_blocks per environment
variable "private_subnet_cidr_blocks" {
  description = "Private subnet CIDR blocks"
  type        = map(list(string))

  default = {
    dev     = ["10.0.4.0/24", "10.0.5.0/24"]
    staging = ["10.1.4.0/24", "10.1.5.0/24"]
    prod    = ["10.2.4.0/24", "10.2.5.0/24"]
  }
}
