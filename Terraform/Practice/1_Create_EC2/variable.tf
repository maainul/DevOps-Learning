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
  default     = "10.0.0.0/16"

}

variable "public_subnet_cidr_blocks" {
  description = "public subnet cidr blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "private subnet cidr block"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]

}
