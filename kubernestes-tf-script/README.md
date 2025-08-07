### Install Terraform 
#### Required version is 1.5.1 or higher
```bash
sudo apt-get install -y unzip
wget https://releases.hashicorp.com/terraform/1.1.5/terraform_1.1.5_linux_amd64.zip
unzip terraform_1.1.5_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform -v
```

### Setup terrafom block to use kubernetes provider
```hcl
terraform {
  required_version = ">= 1.1.5"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}
```
### Create a Terraform configuration file
### This file will define the Kubernetes provider and its configuration
### Ensure you have a valid kubeconfig file at ~/.kube/config
### This file is typically created when you set up kubectl
### If you don't have it, you can create it by running `kubectl config view --raw > ~/.kube/config`
### The following is an example of a simple Terraform configuration file for Kubernetes
### Save this as terraform.tf in your project directory
### This file will be used to manage Kubernetes resources using Terraform
### Ensure you have kubectl installed and configured to access your Kubernetes cluster
touch terraform.tf
```hcl
provider "kubernetes" {
  config_path = "~/.kube/config"
}
```
```bash
mkdir kubernetes-tf-script
cd kubernetes-tf-script
touch terraform.tf
```