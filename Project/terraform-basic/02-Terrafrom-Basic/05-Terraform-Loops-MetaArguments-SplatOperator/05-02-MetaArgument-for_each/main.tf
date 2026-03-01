terraform {
  required_version = "~> 1.12"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

data "aws_availability_zones" "example" {
  filter {
    name = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

output "availability_zones" {
  value = data.aws_availability_zones.example.names
}
