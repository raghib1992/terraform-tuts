
## To **download Provider plugins** mention in provider block
```
terraform init
terraform init --upgrade (in the case dependencies lock file to lock the init to install provider to particular version)
```

## To **delete** the specific resources
```
terraform destroy -target aws_instances.myec2
```
