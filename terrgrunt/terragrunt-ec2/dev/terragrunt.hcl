terraform {
    source = "tfr:///terraform-aws-modules/ec2-instance/aws?version=4.0.0"
}

generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
    provider "aws" {
        profile = "default"
        region  = "eu-north-1"
        shared_credentials_file = ""
        # access_key = "<insert_your_access_key>"
        # secret_key = "<insert_your_secret_key>"
    }
EOF
}