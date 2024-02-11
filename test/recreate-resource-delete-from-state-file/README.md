# Recreate Resource which is deleted from state file


### Step 1: Check the create resources
```t
terraform apply -auto-approve
```

### Step 2: Check the resouce in state file
```t
terraform state list
```

### Step 3: Delete the resouce from state file
```t
terraform state rm aws_ebs_volume.test_ebs
```

### Step 4: Check the resouce in state file
```t
terraform state list
```

### Step 5: Check the resouce recreation plan
```t
terraform plan
```

### Step 2: Check which resource is recreated and it is availablle in terraform


### Get the resouce id from aws
```
terraform import aws_ebs_volume.test_ebs <ebs_id>
```