terraform {
    source = "tfr:///terraform-aws-modules/ec2-instance/aws?version=5.6.1"
}

generate "provider" {
    path      = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents  = <<EOF
    provider "aws" {
        profile = "default"
        region  = "eu-north-1"
#        shared_credentials_files = "/home/raghib/aws_credentials"
    }
EOF
}

inputs = {
    ami  = "ami-01dad638e8f31ab9a"
    instance_type = "t3.small"
    tags = {
        Name = "Uzma: EC2"
    }
}