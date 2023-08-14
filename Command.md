
## To **download Provider plugins** mention in provider block
```
terraform init
terraform init --upgrade (in the case dependencies lock file to lock the init to install provider to particular version)
```

## To **delete** the specific resources
```
terraform destroy -target aws_instances.myec2
```

## To rearrange the terraform tf file
```
terraform fmt
```

## To check the terraform tf file syntactically correct
```
terraform validate
```

## Terraform Taint
### To recreate the terraform resources
```sh
terraform apply -replace="aws_instance.web"
```

## To save the terraform plan as binary file to appply it later
```sh
terraform plan -out=testplan
```

## To see the output without apply, 
```sh
terraform output <attribute name>
terraform output public_ip
```