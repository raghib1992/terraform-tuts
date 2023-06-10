/*
resource "aws_instance" "tuts" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = var.my_instance_type
  count = 2
  #   subnet_id = aws_subnet.tuts-subnet.id
  tags = {
    Name = "tuts-${count.index}"
  }
}

output "count_output" {
    # value = aws_instance.tuts[*].public_ip
    value = [for inst in aws_instance.tuts : inst.private_ip]
}
*/