provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "myec2" {
  ami           = "ami-0da59f1af71ea4ad2"
  instance_type = "t2.micro"
}

resource "aws_eip" "lb" {
  instance = aws_instance.myec2.id
}

resource "aws_security_group" "allow_tls" {
  name = "allow_tls"

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.lb.private_ip}/32"]

  }
}


output "public_ip" {
  value = aws_instance.myec2.public_ip
}