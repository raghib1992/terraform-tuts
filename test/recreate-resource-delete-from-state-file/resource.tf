provider "aws" {
  region = "eu-north-1"
}


data "aws_ami" "amzlnx2" {
    most_recent = true
    filter {
      name = "owner-alias"
      values = [ "amazon" ]
    }
    filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
    }
  
}

resource "aws_instance" "test" {
  ami = data.aws_ami.amzlnx2.id
  instance_type = "t3.micro"
  key_name = "stockholm"
  availability_zone = "eu-north-1a"
  tags = {
    Name = "test"
  }
}

resource "aws_ebs_volume" "test_ebs" {
  availability_zone = "eu-north-1a"
  size = 1
  tags = {
    Name = "test"
  }
}

resource "aws_volume_attachment" "test_ebs_attach" {
  device_name = "/dev/sdh"
  volume_id = aws_ebs_volume.test_ebs.id
  instance_id = aws_instance.test.id
}