resource "aws_instance" "test" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = var.my_instance_type
#   subnet_id = aws_subnet.tuts-subnet.id
key_name = "mumbai-key"

  tags = var.instance_tags
}

