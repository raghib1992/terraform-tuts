# Get Account Id
data "aws_caller_identity" "current" {}

# Get VPC terraform state
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "eks-demo-statefile-terraform"
    key    = "dev/eks/01-vpc/terraform.tfstate"
    region = var.aws_region
  }
}   
