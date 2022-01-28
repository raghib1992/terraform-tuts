resource "aws_instance" "splunk_instance" {
  ami           = "ami-04bcb41b8db548587" # ap-south-2
  instance_type = "t3a.medium"
  iam_instance_profile = aws_iam_instance_profile.splunk-ssm-role-profile.name
  root_block_device {
      delete_on_termination = true  #change to fasle
      encrypted = true
      # kms_key_id = aws_kms_key.a.id
      volume_size = 100 # change to 256
  }
  # subnet_id = "subnet-c9093ea0" # change the tenant subnet id
  #user_data = base64encode(data.template_file.splunk-template.rendered)
  vpc_security_group_ids = [aws_security_group.splunk-sg.id]
  key_name = "raghib-key"
  tags = {
    Name = "splunk-raghib-instance"
    sc_purpose = "trail"
    sc_customer = "raghib"
  }
}

#data "template_file" "splunk-template"{
#  template = file("proxy.template")
#}

resource "aws_iam_instance_profile" "splunk-ssm-role-profile" {
  name = "splunk-raghib-instance-profile"
  role = "raghib-ssm-role-temp-27-april-2021" # get the ssm role in prod
}

resource "aws_security_group" "splunk-sg" {
  name        = "raghib-splunk-sg"
  description = "Allow HTTPS and HTTP inbound traffic"
  vpc_id      = data.aws_vpc.splunk-vpc.id

 ingress {
   from_port = 443
   to_port = 443
   protocol = "tcp"
   cidr_blocks = [ "0.0.0.0/0" ]
   ipv6_cidr_blocks = [ "::/0" ]
 }

 ingress {
   from_port = 80
   to_port = 80
   protocol = "tcp"
   cidr_blocks = [ "0.0.0.0/0" ]
   ipv6_cidr_blocks = [ "::/0" ]
 }

 ingress {
   from_port = 22
   to_port = 22
   protocol = "tcp"
   cidr_blocks = [ "0.0.0.0/0" ]
   ipv6_cidr_blocks = [ "::/0" ]
 }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
  }
}

data "aws_vpc" "splunk-vpc" {
    id = "vpc-bca38cd5" # got the tenant vpc id
}