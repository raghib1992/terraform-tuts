# terraform {
#   required_version = "~> 1.10.0"
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.88.0"
#     }
#   }
# }

# provider "aws" {
#   region = var.aws_region

#   default_tags {
#     tags = {
#       "purpose" = "terragrunt"
#     }
#   }
# }


locals {
  name = var.common_name
  common_tags = {
    name = "${local.name}-${var.environment}"
    env  = var.environment
  }
}
