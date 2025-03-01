# Create VPC Terraform Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  #version = "2.78.0"  
  # version = "~> 2.78"
  version = "~> 5.19.0"  

  # VPC Basic Details
  name = "vpc-dev"
  cidr = "10.2.0.0/16"   
  azs                 = ["eu-north-1a", "eu-north-1b"]
  private_subnets     = ["10.2.1.0/24", "10.2.2.0/24"]
  public_subnets      = ["10.2.101.0/24", "10.2.102.0/24"]

  # Database Subnets
  create_database_subnet_group = true
  create_database_subnet_route_table= true
  database_subnets    = ["10.2.151.0/24", "10.2.152.0/24"]

  #create_database_nat_gateway_route = true
  #create_database_internet_gateway_route = true

  # NAT Gateways - Outbound Communication
  enable_nat_gateway = true
  single_nat_gateway = true

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support = true

  public_subnet_tags = {
    Type = "public-subnets"
  }

  private_subnet_tags = {
    Type = "private-subnets"
  }

  database_subnet_tags = {
    Type = "database-subnets"
  }

  tags = {
    Owner = "kalyan"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "vpc-dev"
  }
}



