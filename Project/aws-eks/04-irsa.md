---
title: EKS IRSA - IAM Roles for Service Accounts
description: Learn the concept EKS IRSA - IAM Roles for Service Accounts
---

## Step-01: Introduction
1. Verify OIDC Provider in EKS Cluster Terraform Manifests
2. Key Resources for discission in this section
   - [EKS OIDC Provider](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts-technical-overview.html)
   - [Kubernetes Service Account](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)
   - [Kubernetes Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/)
   - [EKS IRSA](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)
3. [Terraform Element Function](https://www.terraform.io/language/functions/element)
4. [Terraform Split Function](https://www.terraform.io/language/functions/split)
5. [Terraform merge Function](https://www.terraform.io/language/functions/merge)
6. [Terraform JSONEncode Function](https://www.terraform.io/language/functions/jsonencode)

## Step-02: Verify Terraform State Storage - EKS Cluster
- **Folder:** `13-EKS-IRSA/01-ekscluster-terraform-manifests`
- Verify Terraform State Storage S3 Bucket in `c1-versions.tf` and AWS Mgmt Console
```t
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "terraform-on-aws-eks"
    key    = "dev/eks-cluster/terraform.tfstate"
    region = "us-east-1" 
 
    # For State Locking
    dynamodb_table = "dev-ekscluster"    
  } 
```


## Step-03: Verify Terraform State Locking - EKS Cluster
- **Folder:** `13-EKS-IRSA/01-ekscluster-terraform-manifests`
- Verify Terraform State Locking AWS DynamoDB Table in `c1-versions.tf` and AWS Mgmt Console
```t
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "terraform-on-aws-eks"
    key    = "dev/eks-cluster/terraform.tfstate"
    region = "us-east-1" 
 
    # For State Locking
    dynamodb_table = "dev-ekscluster"    
  } 
```

## Step-04: c6-01-iam-oidc-connect-provider-variables.tf
- **Folder:** `13-EKS-IRSA/01-ekscluster-terraform-manifests`
```t
# EKS OIDC ROOT CA Thumbprint - valid until 2037
variable "eks_oidc_root_ca_thumbprint" {
  type        = string
  description = "Thumbprint of Root CA for EKS OIDC, Valid until 2037"
  default     = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
}
```

## Step-05: eks.auto.tfvars
- **Folder:** `13-EKS-IRSA/01-ekscluster-terraform-manifests`
- Add variable `eks_oidc_root_ca_thumbprint` in `eks.auto.tfvars`
```t
cluster_name = "eksdemo1"
cluster_service_ipv4_cidr = "172.20.0.0/16"
cluster_version = "1.21"
cluster_endpoint_private_access = false
cluster_endpoint_public_access = true
cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
eks_oidc_root_ca_thumbprint = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
```

## Step-06: c6-02-iam-oidc-connect-provider.tf
- **Folder:** `13-EKS-IRSA/01-ekscluster-terraform-manifests`
```t
# Datasource: AWS Partition
# Use this data source to lookup information about the current AWS partition in which Terraform is working
data "aws_partition" "current" {}

# Resource: AWS IAM Open ID Connect Provider
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = [var.eks_oidc_root_ca_thumbprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer

  tags = merge(
    {
      Name = "${var.cluster_name}-eks-irsa"
    },
    local.common_tags
  )
}

# Output: AWS IAM Open ID Connect Provider ARN
output "aws_iam_openid_connect_provider_arn" {
  description = "AWS IAM Open ID Connect Provider ARN"
  value = aws_iam_openid_connect_provider.oidc_provider.arn 
}
```

## Step-07: Extract IAM OIDC Provider from ARN
- **Folder:** `13-EKS-IRSA/01-ekscluster-terraform-manifests`
- **File Name:** c6-02-iam-oidc-connect-provider.tf
```t
# Extract OIDC Provider from OIDC Provider ARN
locals {
    aws_iam_oidc_connect_provider_extract_from_arn = element(split("oidc-provider/", "${aws_iam_openid_connect_provider.oidc_provider.arn}"), 1)
}
# Output: AWS IAM Open ID Connect Provider
output "aws_iam_openid_connect_provider_extract_from_arn" {
  description = "AWS IAM Open ID Connect Provider extract from ARN"
   value = local.aws_iam_oidc_connect_provider_extract_from_arn
}
```
- **Sample Output for reference**
```t
# Sample Outputs for Reference
aws_iam_openid_connect_provider_arn = "arn:aws:iam::180789647333:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/A9DED4A4FA341C2A5D985A260650F232"
aws_iam_openid_connect_provider_extract_from_arn = "oidc.eks.us-east-1.amazonaws.com/id/A9DED4A4FA341C2A5D985A260650F232"
```

## Step-08: Create EKS Cluster: Execute Terraform Commands (If not created)
```t
# Change Directory
cd 13-EKS-IRSA/01-ekscluster-terraform-manifests

# Terraform Init
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve
```
## Step-09: Configure Kubeconfig for kubectl
```t
# Configure kubeconfig for kubectl
aws eks --region <region-code> update-kubeconfig --name <cluster_name>
aws eks --region eu-north-1 update-kubeconfig --name cloud-dev-eksdemo1

# Verify Kubernetes Worker Nodes using kubectl
kubectl get nodes
kubectl get nodes -o wide

# Stop EC2 Bastion Host
Go to Services -> EC2 -> Instances -> hr-dev-BastionHost -> Instance State -> Stop
```

## Step-10: EKS OpenID Connect Well Known Configuration URL
- We can also call it as `OpenID Connect Discovery URL`
- **Discovery:** Defines how Clients dynamically discover information about OpenID Providers
```t
# Get OpenID Connect provider URL for EKS Cluster
Go to Services -> EKS -> hr-dev-eksdemo1 -> Configuration -> Details -> OpenID Connect provider URL

# EKS OpenID Connect Well Known Configuration URL
<EKS OpenID Connect provider URL>/.well-known/openid-configuration

# Sample
https://oidc.eks.us-east-1.amazonaws.com/id/EC973221A6C1BC248C79CFD5455EEECC/.well-known/openid-configuration
```
- **Sample Output from EKS OpenID Connect Well Known Configuration URL**
```json
// 20220106104407
// https://oidc.eks.us-east-1.amazonaws.com/id/EC973221A6C1BC248C79CFD5455EEECC/.well-known/openid-configuration

{
  "issuer": "https://oidc.eks.us-east-1.amazonaws.com/id/EC973221A6C1BC248C79CFD5455EEECC",
  "jwks_uri": "https://oidc.eks.us-east-1.amazonaws.com/id/EC973221A6C1BC248C79CFD5455EEECC/keys",
  "authorization_endpoint": "urn:kubernetes:programmatic_authorization",
  "response_types_supported": [
    "id_token"
  ],
  "subject_types_supported": [
    "public"
  ],
  "claims_supported": [
    "sub",
    "iss"
  ],
  "id_token_signing_alg_values_supported": [
    "RS256"
  ]
}
```

