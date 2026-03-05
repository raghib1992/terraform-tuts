# Terraform Remote State Datasource - Remote Backend AWS S3
data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket         = "eks-demo-statefile-terraform"
    key            = "dev/eks/03-eks/terraform.tfstate"
    region = var.aws_region
  }
}


data "terraform_remote_state" "irsa" {
  backend = "s3"
  config = {
    bucket         = "eks-demo-statefile-terraform"
    key            = "dev/eks/04-irsa/terraform.tfstate"
    region = var.aws_region
  }
}


data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}