/*
resource "aws_instance" "tuts" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = each.value
    for_each = {
      "prod" = "t2.small"
      "dev"  = "t3.micro"
    }
  #   subnet_id = aws_subnet.tuts-subnet.id
  tags = {
    Name = "tuts-${each.key}"
  }
}


output "inst" {
    # value = aws_instance.tuts["prod"].public_ip
  value = [for inst in aws_instance.tuts : inst.public_ip]
}
*/