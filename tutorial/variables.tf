variable "my_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Define instance type here"
}

variable "my_profile" {
}

variable "instance_tags" {
  type = object({
    Name = string
    foo  = number
  })
  default = {
    Name = "temporary"
    foo  = 9
  }
}