# Terraform Settings Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = "~> 5.87" # Optional but recommended in production
    }
  }
}

# Provider Block
provider "aws" {
  profile = "default" # AWS Credentials Profile configured on your local desktop terminal  $HOME/.aws/credentials
  region  = "eu-north-1"
}

# Resource Block
resource "aws_instance" "ec2demo" {
  ami           = "ami-07a64b147d3500b6a" # Amazon Linux in us-east-1, update as per your region
  instance_type = "t3.micro"
}
