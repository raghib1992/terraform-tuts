/*
locals {
  setup_name  = "tuts"
  environmant = "dev"
  foobar      = "Nadim"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    # Name = "tuts-vpc"
    Name = "${local.setup_name}-vpc"
  }
}

resource "aws_subnet" "web" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

  tags = {
    # Name = "tuts-subnet"
    Name = "${local.setup_name}-subnet"
  }
}

resource "aws_instance" "web-app" {
  instance_type = var.my_instance_type
  ami = data.aws_ami.amazon-linux-2.id

  tags = {
    # Name = "tuts-instance"
    Name = "${local.setup_name}-instance"
    env = local.environmant
    foo = local.foobar
  }
}
*/

