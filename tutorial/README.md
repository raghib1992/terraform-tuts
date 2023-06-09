# TO validate terraform script
terraform validate

# to correct the format 
terraform fmt

# to download required plugins
terraform init

# to check the what terraform do without doing
terraform plan

# to execute terraform
terrafrm apply
terraform apply -auto-approve

# to delete
terraform destroy


# pass varibale file 
terraform apply -auto-approve -var-file dev.tfvars
# pass variable
terraform apply -auto-approve -var="my_instance_type=t2.large"
TF_VAR_my_instance_type="t2.large" terraform apply



# TO check the output 
```
output "instance_public_ip" {
    value = aws_instance.test.public_ip  
}

output "ami_id" {
  value = data.aws_ami.amazon-linux-2.id
}
```
terraform output
terraform output ami_id