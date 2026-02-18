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



# Get latest AMI ID for Amazon Linux2 OS
data "aws_ami" "amzlinux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}