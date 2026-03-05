# Terraform Settings Block
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = ">= 4.65"
      version = ">= 6.34"
     }
    helm = {
      source = "hashicorp/helm"
      #version = "2.4.1"
      #version = "~> 2.4"
      version = "~> 3.1"
    }
    http = {
      source = "hashicorp/http"
      #version = "2.1.0"
      #version = "~> 2.1"
      version = "~> 3.3"
    }
  }
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket         = "eks-demo-statefile-terraform"
    key            = "dev/eks/06-ebs-csi-self-driver/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    use_lockfile   = true
  }   
}

# Terraform AWS Provider Block
provider "aws" {
  region = var.aws_region
}

# Terraform HTTP Provider Block
provider "http" {
  # Configuration options
}

provider "helm" {
  kubernetes = {
    host = data.terraform_remote_state.eks.outputs.cluster_endpoint 
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
    token = data.aws_eks_cluster_auth.cluster.token
  }
}