resource "aws_key_pair" "node_ssh_key" {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0+SKlHi5RbmytKVU0sk+LVOyoRMPykEWGjTJSYBdp2sRpxrI+GHgG/b3YHna/Et1/mO+GUqu1BVWWoWfYUUhvnNvI7gRojATxKDXW+O4oILKIKVuXnn0s2gysjNfmryDYO2RMGoKtHttv6wi3OM/HqCkrT96xCfTr/3MZGwaA3dLSX8/K4arHAUxm7OWrAU2Q3Lq02DbMf/Sl5ZDOibGSYcBlEW3fnzzKmEjjX+c07WknQJKrEjkjcWO1HRktMOfQTZPawcHRNQXwf2aGpkFzUGQsu00jnAIfeJ/GA1X7yeAQ70DFjPCtANXeTl2VhzhtZ+3NcMoKm5z2GUBd2aQUld3qeJh34Pn6nAmWqUcDvUbCDvGDVxkwsWYliPP4bNeHYasgMycbAXOJHhX9fYI5j9LTYNTifIm7SWeWPwnSYdIQzox07bueKJz8o83NK3ZIHoqD8R7bQhjofN558n8PzFYhG9mljTsyOpcwuD9ODtrR39Z6QX0WHOzR0kfSXu0= raghib@raghib"
  key_name = var.nodegroup_keypair
}