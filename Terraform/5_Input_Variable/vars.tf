
variable "instance_type" {
  description = "instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "number of instance created"
  type        = number
  default     = 2
}

variable "user_names" {
  description = "IAM Users"
  type        = list(string)
  default     = ["demo1", "demo2", "demo3"]
}