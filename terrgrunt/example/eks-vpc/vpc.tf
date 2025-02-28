# terraform vpc cofiguration file
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.10.0.0/16"

  tags = local.common_tags
}

resource "aws_eip" "eks_eip" {
  domain = "vpc"

  tags = local.common_tags
}

