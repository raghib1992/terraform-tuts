provider "aws" {
  region = "ap-south-1"
}

import {
  to = aws_security_group.linux_admin
  id = "sg-0fc92442570690a59"
}