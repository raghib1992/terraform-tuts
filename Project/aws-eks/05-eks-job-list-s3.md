
## Step-10: Pre-requisite-1: Create folder in S3 Bucket (Optional)
- This step is optional, Terraform can create this folder `dev/ebs-storage` during `terraform apply` but to maintain consistency we create it. 
- Go to Services -> S3 -> 
- **Bucket name:** terraform-on-aws-eks
- **Create Folder**
  - **Folder Name:** dev/eks-irsa-demo
  - Click on **Create Folder**  

## Step-11: Pre-requisite-2: Create DynamoDB Table
- Create Dynamo DB Table for EKS IRSA Demo
  - **Table Name:** dev-eks-irsa-demo
  - **Partition key (Primary Key):** LockID (Type as String)
  - **Table settings:** Use default settings (checked)
  - Click on **Create**

## Step-12: c1-versions.tf
- **Folder:** 02-eks-irsa-demo-terraform-manifests
```t
# Terraform Settings Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.70"
     }
  }
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "terraform-on-aws-eks"
    key    = "dev/eks-irsa-demo/terraform.tfstate"
    region = "us-east-1" 

    # For State Locking
    dynamodb_table = "dev-eks-irsa-demo"    
  }     
}
```
## Step-13: c2-remote-state-datasource.tf
- **Folder:** 02-eks-irsa-demo-terraform-manifests
```t
# Terraform Remote State Datasource - Remote Backend AWS S3
data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "terraform-on-aws-eks"
    key    = "dev/eks-cluster/terraform.tfstate"
    region = var.aws_region
  }
}
```
## Step-14: c3-01-generic-variables.tf
- **Folder:** 02-eks-irsa-demo-terraform-manifests
```t
# Input Variables - Placeholder file
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "us-east-1"  
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type = string
  default = "dev"
}
# Business Division
variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type = string
  default = "SAP"
}

```
## Step-15: c3-02-local-values.tf
- **Folder:** 02-eks-irsa-demo-terraform-manifests
```t
# Define Local Values in Terraform
locals {
  owners = var.business_divsion
  environment = var.environment
  name = "${var.business_divsion}-${var.environment}"
  common_tags = {
    owners = local.owners
    environment = local.environment
  }
  eks_cluster_name = "${local.name}-${data.terraform_remote_state.eks.outputs.cluster_id}"  
} 
```

## Step-16: c4-01-providers.tf
- **Folder:** 02-eks-irsa-demo-terraform-manifests
```t
# Terraform AWS Provider Block
provider "aws" {
  region = "us-east-1"
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

# Terraform Kubernetes Provider
provider "kubernetes" {
  host = data.terraform_remote_state.eks.outputs.cluster_endpoint 
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
  token = data.aws_eks_cluster_auth.cluster.token
}
```

## Step-17: c4-02-irsa-iam-policy-and-role.tf
- **Folder:** 02-eks-irsa-demo-terraform-manifests
```t
#data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_arn
#data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_extract_from_arn

# Resource: Create IAM Role and associate the EBS IAM Policy to it
resource "aws_iam_role" "irsa_iam_role" {
  name = "${local.name}-irsa-iam-role"

  # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_arn}"
        }
        Condition = {
          StringEquals = {            
            "${data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_extract_from_arn}:sub": "system:serviceaccount:default:irsa-demo-sa"
          }
        }        

      },
    ]
  })

  tags = {
    tag-key = "${local.name}-irsa-iam-role"
  }
}

# Associate IAM Role and Policy
resource "aws_iam_role_policy_attachment" "irsa_iam_role_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.irsa_iam_role.name
}

output "irsa_iam_role_arn" {
  description = "IRSA Demo IAM Role ARN"
  value = aws_iam_role.irsa_iam_role.arn
}
```

## Step-18: c4-03-irsa-k8s-service-account.tf
- **Folder:** 02-eks-irsa-demo-terraform-manifests
```t
# Resource: Kubernetes Service Account
resource "kubernetes_service_account_v1" "irsa_demo_sa" {
  depends_on = [ aws_iam_role_policy_attachment.irsa_iam_role_policy_attach ]
  metadata {
    name = "irsa-demo-sa"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.irsa_iam_role.arn
      }
  }
}
```

## Step-19: c4-04-irsa-k8s-job.tf
- **Folder:** 02-eks-irsa-demo-terraform-manifests
```t
# Resource: Kubernetes Job
resource "kubernetes_job_v1" "irsa_demo" {
  metadata {
    name = "irsa-demo"
  }
  spec {
    template {
      metadata {
        labels = {
          app = "irsa-demo"
        }
      }
      spec {
        service_account_name = kubernetes_service_account_v1.irsa_demo_sa.metadata.0.name 
        container {
          name    = "irsa-demo"
          image   = "amazon/aws-cli:latest"
          args = ["s3", "ls"]
          #args = ["ec2", "describe-instances", "--region", "${var.aws_region}"] # Should fail as we don't have access to EC2 Describe Instances for IAM Role
        }
        restart_policy = "Never"
      }
    }
  }
}
```
## Step-20: terraform.tfvars
- **Folder:** 02-eks-irsa-demo-terraform-manifests
```t
# Generic Variables
aws_region = "us-east-1"
environment = "dev"
business_divsion = "hr"
```
## Step-21: Execute Terraform Commands
- **Folder:** 02-eks-irsa-demo-terraform-manifests
```t
# Change Directory
cd 13-EKS-IRSA/02-eks-irsa-demo-terraform-manifests

# Terraform Init
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve
```

## Step-22: Verify Resources
```t
# Verify Kubernetes Service Account
kubectl get sa
kubectl describe sa irsa-demo-sa
Observation:
1. We can see that IAM Role ARN is associated in Annotations field of Kubernetes Service Account

# List & Describe Kubernetes Jobs
kubectl get job
kubectl describe job irsa-demo
Observation:
1. You should see COMPLETIONS 1/1
2. You should see when you describe Pods Statuses:  0 Running / 1 Succeeded / 0 Failed

# Verify Logs (by giving job label app=irsa-demo)
kubectl logs -f -l app=irsa-demo
Observation: 
1. You can see all the S3 buckets from your AWS account listed
```

## Step-23: Option-1: Terraform Taint Command: Re-execute the Job using terraform
- Our core focus here is to learn [terraform taint command](https://www.terraform.io/cli/commands/taint)
```t
# Change Directory
cd 13-EKS-IRSA/02-eks-irsa-demo-terraform-manifests

# List Terraform Resources
terraform state list

# Taint Kubernetes Job
terraform taint kubernetes_job_v1.irsa_demo
Observation: 
1. Terraform taint will ensure the resource will get destroyed and recreated during next terraform apply.

# Terraform Plan
terraform plan
Observation: 
1. We should see a message  "kubernetes_job_v1.irsa_demo is tainted, so must be replaced"

# Terraform Plan
terraform apply -auto-approve
Observation:
1. Resource kubernetes_job_v1.irsa_demo should be destroyed and recreated.

# Verify Kubernetes Job
kubectl get job
kubectl describe job irsa-demo
kubectl logs -f -l app=irsa-demo
Observation:
1. k8s Job should run successfully.
```

## Step-24: Option-2: Terraform apply -replace Command: Re-execute the Job using terraform
- Our core focus here is to learn [terraform apply -replace](https://www.terraform.io/cli/commands/taint) command
- Instead of `terraform taint` we can also use `terraform apply -replace` command
```t
# Change Directory
cd 13-EKS-IRSA/02-eks-irsa-demo-terraform-manifests

# List Terraform Resources
terraform state list

# Verify AGE column of job before running replace
kubectl get job irsa-demo

# Terraform Apply with "-replace" option for Kubernetes Job
terraform apply -replace kubernetes_job_v1.irsa_demo 
Observation: 
1. Terraform apply  with "replace" option will ensure the existing resource will get destroyed and recreated with single command.

# Verify Kubernetes Job
kubectl get job
kubectl describe job irsa-demo
kubectl logs -f -l app=irsa-demo
Observation:
1. k8s Job should run successfully.
```
## Step-25: Option-3: Re-execute the Job using terraform and kubectl
- Delete the k8s Job with `kubectl` and create it with `terraform apply`
```t
# Delete the Job with kubectl
kubectl delete job irsa-demo

# Run terraform plan
terraform plan
Observation:
1. It will show that 1 resource to be created which is irsa-demo job

# Run terraform apply
terraform apply -auto-approve
Observation:
1. We should see that irsa-demo job created succesfully

# Verify Kubernetes Job
kubectl get job
kubectl describe job irsa-demo
kubectl logs -f -l app=irsa-demo
Observation:
1. k8s Job should run successfully.
```

## Step-25: CleanUp - IRSA Demo
```t
# Change Directory
cd 13-EKS-IRSA/02-eks-irsa-demo-terraform-manifests

# Terraform Destroy
terraform destroy -auto-approve

# Delete Terraform Provider Plugins
rm -rf .terraform*
```

## Step-26: CleanUp - EKS Cluster (Optional)
- If you are moving to next section now, don't destroy the EKS Cluster
```t
# Change Directory
cd 13-EKS-IRSA/01-ekscluster-terraform-manifests

# Terraform Destroy
terraform destroy -auto-approve

# Delete Terraform Provider Plugins
rm -rf .terraform*
```





## Refefences
