# terraform block to use kubernetes provider
terraform {
  required_version = "~> 0.1.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }
}

provider "kubernetes" {
  config_path = "/root/.kube/config"
}