
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "frontend_cidr_block" {
  default = "10.0.1.0/24"
}

variable "backend_cidr_block" {
  default = "10.0.2.0/24"
}

variable "jenkins_cidr_block" {
  default = "10.0.3.0/24"
}

variable "username" {
  default = "dev_admin"
}

variable "password" {
  default = "Mainul1234"
}


variable "key_pair_name" {
  default = "fast-food"
}
