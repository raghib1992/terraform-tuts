# Terraform Settings Block
terraform {
  required_version = ">= 1.12.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.27"
      # version = ">= 6.27"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 3.0"
      # version = ">= 2.20"
    }    
  }
}
