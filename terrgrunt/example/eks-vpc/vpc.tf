# terraform vpc cofiguration file
resource "aws_vpc" "eks_vpc" {
  cidr_block = var.vpc_cidr

  tags = local.common_tags
}

resource "aws_eip" "eks_eip" {
  domain = "vpc"

  tags = local.common_tags
}

