terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }    
  }
}

provider "aws"{
  region = "eu-north-1"
}

variable "istest" {
  type = bool
  default = false
}

resource "aws_instance" "prod" {
   ami = "ami-082b5a644766e0e6f"
   instance_type = var.istest == true ? "t3.micro":"t2.small"
  #  count = var.istest == false ? 1 : 0
  # condition ? value_if_true : value_if_false
}

variable "ports" {
  type = list(number)
  default = [80,443,8080,8888]
}

resource "aws_security_group" "http_rule" {
  name = "http_sg"
  dynamic "ingress" {
    for_each = var.ports
    content {
      description = "http"
      to_port = ingress.value
      from_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}