variable "aws_region" {
  description = "AWS Region where resouce created"
  type        = string
  default     = "eu-north-1"
}

variable "common_name" {
  type    = string
  default = "my_eks"
}

variable "environment" {
  type    = string
  default = "Development"
}

variable "public_subnet" {
  description = "public subnet"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnet" {
  description = "public subnet"
  type        = list(string)
  default     = ["10.10.3.0/24", "10.10.4.0/24"]
}

variable "azs" {
  default = ["eu-north-1a", "eu-north-1b"]
  type    = list(string)
}

variable "pub_sub_tags" {
  description = "Provide tags that needs to be as part of EKS network to manage ELB internet-facing"
  type        = map(any)
  default = {
    "kubernetes.io/role/elb" = "1"
  }
}

variable "priv_sub_tags" {
  description = "Provide tags that needs to be as part of EKS network to manage ELB internal-elb"
  type        = map(any)
  default = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}