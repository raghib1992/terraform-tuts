resource "aws_instance" "test" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = var.my_instance_type
  key_name      = "mumbai-key"
  tags          = var.instance_tags

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > public_ip.txt"
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    host = self.public_ip
    private_key = file("C:/Users/raghi/Desktop/mumbai-key.pem")
  }



  provisioner "file" {
    content     = <<EOF
print("Hello World")
    EOF
    destination = "/home/ec2-user/hello.py"
  }

  provisioner "remote-exec" {
    on_failure = "continue"
    # on_failure = "fail"
    inline = [ 
        "python3 /home/ec2-user/hello.py"
     ]
  }
}

output "aws_pubilc_ip" {
  value = aws_instance.test.public_ip
}