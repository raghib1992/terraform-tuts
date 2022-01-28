# {
#     "Parameters": [
#         {
#             "Name": "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended",
#             "Type": "String",
#             "Value": "{\"schema_version\":1,\"image_name\":\"amzn2-ami-ecs-hvm-2.0.20211103-x86_64-ebs\",\"image_id\":\"ami-04bcb41b8db548587\",\"os\":\"Amazon Linux 2\",\"ecs_runtime_version\":\"Docker version 20.10.7\",\"ecs_agent_version\":\"1.57.0\"}",
#             "Version": 76,
#             "LastModifiedDate": "2021-11-06T00:02:30.549000+05:30",
#             "ARN": "arn:aws:ssm:ap-south-1::parameter/aws/service/ecs/optimized-ami/amazon-linux-2/recommended",
#             "DataType": "text"
#         }
#     ],
#     "InvalidParameters": []
# }
# resource "aws_kms_key" "a" {
#   description             = "this is to encrypt and decrypt the splunk root volume"
#   deletion_window_in_days = 7
#   tags = {
#     Name = "splunk-${var.name_prefix}-key"
#     sc_purpose = "trail"
#     sc_customer = var.name_prefix
#   }
# }
resource "aws_kms_key" "splunk-kms" {
  description             = "this is to encrypt and decrypt the splunk root volume"
  deletion_window_in_days = 10
  tags = {
    Name = "splunk-${var.name_prefix}-key"
    sc_purpose = "trail"
    sc_customer = var.name_prefix
  }
}

resource "aws_route53_record" "splunk-instance" {
  zone_id = var.route53_zone_id
  name    = "splunk.${var.name_prefix}"
  type    = "A"
  ttl     = "60"
  records = [aws_eip.splunk-eip.public_ip]
}

resource "aws_eip_association" "splunk_eip_assoc" {
  instance_id   = aws_instance.splunk_instance.id
  allocation_id = aws_eip.splunk-eip.id
}

resource "aws_eip" "splunk-eip" {
  vpc = true
  tags = {
    Name = "splunk-${var.name_prefix}-eip"
    sc_purpose = "trail"
    sc_customer = var.name_prefix
  }
}

data "aws_vpc" "splunk-vpc" {
    id = "vpc-bca38cd5" # got the tenant vpc id
}

resource "aws_security_group" "splunk-sg" {
  name        = "${var.name_prefix}-splunk-sg"
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

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
  }

  tags = {
    Name = "splunk-${var.name_prefix}-sg"
  }

}

resource "aws_iam_instance_profile" "splunk-ssm-role-profile" {
  name = "splunk-${var.name_prefix}-instance-profile"
  role = "raghib-ssm-role-temp-27-april-2021" # get the ssm role in prod
}

resource "aws_instance" "splunk_instance" {
  ami           = "ami-04bcb41b8db548587" # ap-south-2
  instance_type = "t3a.medium"
  iam_instance_profile = aws_iam_instance_profile.splunk-ssm-role-profile.name
  root_block_device {
      delete_on_termination = true  #change to fasle
      encrypted = true
      kms_key_id = aws_kms_key.splunk-kms.id
      volume_size = 100 # change to 256
  }
  subnet_id = "subnet-c9093ea0" # change the tenant subnet id
  user_data = base64encode(data.template_file.splunk-template.rendered)
  vpc_security_group_ids = [aws_security_group.splunk-sg.id]
  tags = {
    Name = "splunk-${var.name_prefix}-instance"
    sc_purpose = "trail"
    sc_customer = var.name_prefix
  }
}

data "template_file" "splunk-template"{
    template = file("test.template")
    
    vars = {
        customer = var.name_prefix
    #     # uuid = var.UUID
    #     # caddy_auth = var.CADDY_AUTH
    }
}