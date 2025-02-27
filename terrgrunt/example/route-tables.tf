resource "aws_route_table" "eks_private_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = local.common_tags
}

resource "aws_route_table" "eks_public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = local.common_tags
}

resource "aws_route" "eks_igw_route" {
  route_table_id         = aws_route_table.eks_public_rt.id
  gateway_id             = aws_internet_gateway.eks_ig.id
  depends_on             = [aws_internet_gateway.eks_ig]
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "eks_ngw_route" {
  route_table_id         = aws_route_table.eks_public_rt.id
  nat_gateway_id         = aws_nat_gateway.eks_nat.id
  depends_on             = [aws_internet_gateway.eks_ig]
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "eks_pri_rt_ass" {
  count          = length(var.private_subnet)
  subnet_id      = element(aws_subnet.eks_private_subnet[*].id, count.index)
  route_table_id = aws_route_table.eks_private_rt.id
}

resource "aws_route_table_association" "eks_pub_rt_ass" {
  count          = length(var.public_subnet)
  subnet_id      = element(aws_subnet.eks_public_subnet[*].id, count.index)
  route_table_id = aws_route_table.eks_public_rt.id
}