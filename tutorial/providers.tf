provider "aws" {
  alias  = "dev"
  region = "us-east-1"
}

data "aws_ami" "amazon-linux-3" {
  provider = aws.dev
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*-x86_64-ebs"]
  }
}

resource "aws_instance" "tuts" {
  provider      = aws.dev
  ami           = data.aws_ami.amazon-linux-3.id
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
