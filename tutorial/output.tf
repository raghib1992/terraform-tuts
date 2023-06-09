output "vpc_details" {
  value     = aws_vpc.main
  sensitive = true
}

output "instance_public_ip" {
  value = aws_instance.test.public_ip
}

output "ami_id" {
  value = data.aws_ami.amazon-linux-2.id
}