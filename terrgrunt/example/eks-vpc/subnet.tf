resource "aws_subnet" "eks_public_subnet" {
  count                   = length(var.public_subnet)
  vpc_id                  = aws_vpc.eks_vpc.id
  map_public_ip_on_launch = true
  cidr_block              = element(var.public_subnet, count.index)
  availability_zone = element(var.azs, count.index)

  tags = merge(
    var.pub_sub_tags,
    local.common_tags,
    {
      "Name" = "${var.environment}-public-subnet-${element(var.public_subnet, count.index)}"
    }
  )
}

resource "aws_subnet" "eks_private_subnet" {
  count                   = length(var.private_subnet)
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block              = element(var.private_subnet, count.index)
  availability_zone = element(var.azs, count.index)

  tags = merge(
    var.priv_sub_tags,
    local.common_tags,
    {
      "Name" = "${var.environment}-private-subnet-${element(var.private_subnet, count.index)}"
    }
  )
}