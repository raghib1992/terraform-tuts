provider "aws" {
  region = "ap-south-1"
}


module "myec2" {
  source = ".\\Modules\\ec2"
  # instance_type = "t2.large"
}


resource "aws_eip" "bar" {
  vpc = true
  instance  = module.myec2.inst.id
}

output "myip" {
  value = module.myec2.inst.public_ip
}