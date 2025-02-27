- Locals blocks provides a way to define alias in within the configuration files
- It would like same as Terraform locals variable
- To locals variables to the confwe use # local.ARG_NAME

```
local {
    aws_region = "eu-north-1"
}

inputs = {
    region = local.aws_region
    name = "${local.aws_region}-bucket"
}