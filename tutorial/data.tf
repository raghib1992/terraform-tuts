# data "aws_vpc" "main" {
#     default = true  
# }

data "aws_vpc" "main" {
  # default = true
  filter {
    name   = "tag:Name"
    values = ["More"]
  }
}

output "vpc_main_id" {
  description = "Fetching the default vpc id"
  value       = data.aws_vpc.main.id
}

# data "aws_subnet" "selected" {
#   id = var.subnet_id
# }

resource "aws_subnet" "tuts-subnet" {
    vpc_id = data.aws_vpc.main.id
    cidr_block = "10.5.0.0/24"
}
