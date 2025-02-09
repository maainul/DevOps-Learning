
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}


variable "jenkins_cidr_block" {
  default = "10.0.3.0/24"
}

variable "username" {
  default = "sonar"
}

variable "password" {
  default = "Mainul1234"
}


variable "key_pair_name" {
  default = "fast-food"
}
