provider "aws" {
  region = local.region
}

data "aws_caller_identity" "current" {}

provider "archive" {}

locals {
  common_tags = {
    sc_purpose = "sc-saas"
  }
  region = "ap-south-1"
}