variable "vpc_cidr" {
  default = "10.150.0.0/22"
}

variable "az_count" {
    default = 2  
}

variable "public_subnet_cidrs" {
    default = {
    zone0 = "10.150.0.0/24"
    zone1 = "10.150.1.0/24"
  }
}

variable "private_subnet_cidrs" {
    default = {
    zone0 = "10.150.2.0/24"
    zone1 = "10.150.3.0/24"
  }
}

variable "aws_azs" {
  description = "comma separated string of availability zones in order of precedence"
  default     = "ap-south-1a, ap-south-1b"
}

variable "enable_hostname" {
  default = false
}

variable "enable_dns_support" {
  default = false
}

variable "env" {
  default = "test"
}

variable "server-name" {
  default = "splunk"
}

variable "count" {
  default = 2
}