variable "env" {
  description = "Dev Enviorment"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "Env must be dev,staging or prod"
  }
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS Profile Name"
  type        = string
  default     = "default"
}

variable "ami" {
  description = "Ami Code"
  type        = string
  default     = "ami-04b4f1a9cf54c11d0"
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
  default     = "t2.micro"
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
  description = "Public subnet cidr blocks"
  type        = map(list(string))

  default = {
    dev     = ["10.0.1.0/24"]
    staging = ["10.1.1.0/24"]
    prod    = ["10.2.1.0/24"]
  }
}


variable "security_groups" {
  description = "List of security groups"
  type = list(object({
    cidr_blocks = list(string)
    from_port   = number
    to_port     = number
    protocol    = string
  }))
  default = [
    { cidr_blocks = ["0.0.0.0/0"], from_port = 80, to_port = 80, protocol = "tcp" },
    { cidr_blocks = ["0.0.0.0/0"], from_port = 22, to_port = 22, protocol = "tcp" },
    { cidr_blocks = ["0.0.0.0/0"], from_port = 3000, to_port = 3000, protocol = "tcp" }
  ]
}
