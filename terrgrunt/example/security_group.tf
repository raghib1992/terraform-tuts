resource "aws_security_group" "default_group" {
  name        = "${var.environment}-default-sg"
  description = "Add to public subnet"
  vpc_id      = aws_vpc.eks_vpc.id
  depends_on = [
    aws_vpc.eks_vpc
  ]

  tags = local.common_tags
}


resource "aws_security_group_rule" "default_rules" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default_group.id
}
resource "aws_security_group_rule" "web_rules" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default_group.id
}
resource "aws_security_group_rule" "default_egress_rules" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default_group.id
}