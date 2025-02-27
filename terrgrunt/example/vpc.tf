# terraform vpc cofiguration file
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.10.0.0/16"

  tags = local.common_tags
}

resource "aws_subnet" "eks_public_subnet" {
  count                   = length(var.public_subnet)
  vpc_id                  = aws_vpc.eks_vpc.id
  map_public_ip_on_launch = true
  cidr_block              = element(var.public_subnet, count.index)
  availability_zone = element(var.azs, count.index)

  tags = local.common_tags
}

resource "aws_subnet" "eks_private_subnet" {
  count                   = length(var.private_subnet)
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block              = element(var.private_subnet, count.index)
  availability_zone = element(var.azs, count.index)

  tags = local.common_tags
}

resource "aws_eip" "eks_eip" {
  domain = "vpc"

  tags = local.common_tags
}

resource "aws_nat_gateway" "eks_nat" {
  subnet_id     = element(aws_subnet.eks_public_subnet.*.id, 0)
  allocation_id = aws_eip.eks_eip.id
  depends_on = [
    aws_eip.eks_eip,
    aws_subnet.eks_public_subnet
  ]

  tags = local.common_tags
}

resource "aws_internet_gateway" "eks_ig" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = local.common_tags
}