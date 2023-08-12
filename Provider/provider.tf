terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  # profile = "default"
  # hardcore local path make issue for larger team
  # shared_config_files       = ["/Users/raghi/.aws/conf"]
  # shared_credentials_files  = ["/Users/raghi/.aws/creds"]
}

# provider "azurerm" {}

# terraform {
#   required_providers {
#     alicloud = {
#       source = "aliyun/alicloud"
#       version = "1.209.0"
#     }
#   }
# }

# provider "alicloud" {
#   # Configuration options
# }

/*
>=1.0 Greater than equal to version
<=1.0 Less than equal to version
~>2.0 Any version in range 2.X
>=2.10,<= 2.30 Any version between 2.10 to 2,30
*/