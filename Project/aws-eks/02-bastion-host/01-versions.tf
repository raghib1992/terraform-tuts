# Terraform Settings Block
terraform {
  required_version = ">= 1.12.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = ">= 4.65"
      version = ">= 5.31"
    }
  }
  backend "s3" {
    bucket         = "eks-demo-statefile-terraform"
    key            = "dev/eks/02-bastion-host/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    use_lockfile   = true
  }
}

# Terraform Provider Block
provider "aws" {
  region = var.aws_region
}