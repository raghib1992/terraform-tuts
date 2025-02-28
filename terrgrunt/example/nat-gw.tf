resource "aws_nat_gateway" "eks_nat" {
  subnet_id     = element(aws_subnet.eks_public_subnet.*.id, 0)
  allocation_id = aws_eip.eks_eip.id
  depends_on = [
    aws_eip.eks_eip,
    aws_subnet.eks_public_subnet
  ]

  tags = local.common_tags
}