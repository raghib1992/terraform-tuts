

resource "aws_instance" "myec2" {
   ami = "ami-0d951b011aa0b2c19"
   instance_type = var.instance_type
   key_name = "mumbai-key"
   vpc_security_group_ids  = [aws_security_group.allow_ssh.id]

   provisioner "remote-exec" {
    # even if resource configuration fail due to this remote-exec, dont mark the resource as taint
    #  on_failure = continue
     inline = [
       "sudo amazon-linux-extras install -y nginx1",
       "sudo systemctl start nginx"
     ]
   }
   connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("D:\\AWS_Secret_File\\mumbai-key.pem")
     host = self.public_ip
   }
}

output "inst"{
  value = aws_instance.myec2
}