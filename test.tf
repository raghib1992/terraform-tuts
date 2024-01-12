provider "aws"{
  region = "eu-north-1"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  dynamic "range"{
    for_each = ["10.0.0.0/24","10.0.1.0/24]
    content {
      cidr_block = range.value
      tags = {
        Name = "Main"
      }
    }
  } 
}