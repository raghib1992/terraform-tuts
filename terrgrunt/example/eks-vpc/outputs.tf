output "vpc_name" {
    description = "Display VPC Name on eks network"
    value = aws_vpc.eks_vpc.id
}

output "pub_subnets" {
    description = "Public subnet that will be used by eks cluster"
    value = aws_subnet.eks_public_subnet[*].id  
}

output "priv_subnets" {
    description = "Privte subnet that will be used by eks cluster"
    value = aws_subnet.eks_private_subnet[*].id  
}

output "sg_name" {
  description = "List security group name used for EKS Cluster control plane"
  value       = aws_security_group.default_group.id
}