provider "aws" {
  region = "ap-south-1"
}


resource "aws_instance" "myec2" {
  ami           = "ami-0d951b011aa0b2c19"
  instance_type = "t2.micro"
  key_name      = "mumbai-key"

  provisioner "local-exec" {
    command = "echo ${aws_instance.myec2.private_ip} >> private-ip.txt"
  }
}

output "public-ip" {
  value = aws_instance.myec2.public_ip
}


