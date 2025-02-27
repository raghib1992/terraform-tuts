1. inputs
- To pass inputs variables and values to Terraform resource.
- we define in ap format
- map details of inputs attributes are passed as environment variable to terraform 
- FOr example, TF_VARS_instance_type with value in JSON encoded format, similarto terraform env variable.
- Limitation: Type information lostwhen variable are passed from terragrunt to terraform variable.
- FOr which we have t odefine variable blocks with proper type attribute isn terraform  variable file.
- Inputs variable accept string, Integer, Boolean, list of string, Integer, Boolean values, map of string, number, boolena, oject and from_env

2. download_dir
- To specify the download path for terragrunt, instead of default location/path
- Default path Terragrunt save terraform configuration files in working directory under: “.terragrunt-cache”
- Order that terragrunt follows:
    - --terragrunt-download-dir passed in terragrunt CLI
    - TERRAGRUNT_DOWNLOAD defined through Environment variable
    - Terragrunt.hcl defined with download_dir attribute
    - Module directory
    - Include block in terragrunt.hcl

3. Prevent_destroy attribute
- It protects selected modules from accidental deletion
- While executing commands like #terragrunt destroy or terragrunt destroy-all
- This option will helps to carefully protect for critical workloads like VPC, RDS
```
prevent_destroy = true
```

4. Skip attribute
- In order to ignore the changes done in the specific module, we use skip attribute
- Terragrunt commands will skip that specific module where we have defined skip attribute with true value
- Skip attribute will be defined in terragrunt.hcl configuration files (skip = true)

5. Terraform_binary
- We have to use terraform_binary attribute, when we have placed terraform binary/package in custom path
- In some cases, we will not store binaries in default $PATH location.
- Order to define this attribute:
    - --terragrunt-tfpath from CLI
    - TERRAGRUNT_TFPATH
    - Terragrunt.hcl in module directory


6. Terraform_version_constraint
- If we want to use a specific terraform version
- Some cases, we will develop Terraform configuration files on specific version of Terraform which may be not
compatible with older versions or any
- Entry in terragrunt configuration file #terraform_version_constraint = “>= 1.2.5”

7. Terragrunt_version_constraint
- If we want to use a specific terragrunt version
- In some cases, the attributes and blocks etc., we use may be deprecated or removed which will cause errors
- Entry in terragrunt configuration file #terragrunt_version_constraint = “>= 0.38.0”


8. iam_role
- AWS IAM service provides Role for authentication
- Roles can be assumed by Users (IAM Users and Federated users) and AWS Service to communicate to AWS Services
- Terragrunt/Terraform will use that Role as specified to authenticate to AWS Account
- Argument to define iam_role in terragrunt configuration file
    - iam_role = “arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME”
    - Note: we can pass IAM role in CLI, ENV, CONFIG

9. iam_assume_role_duration
- AWS IAM assume role duration will provide STS session duration in seconds
- This IAM role will be assumed by Terragrunt to contact AWS Services and perform the task within the
duration specified (This value has to be less or equal to the value defined by the AWS Account administrator)
- AWS STS Session default value 1 hour (3600 seconds)
- Argument to define in configuration file
    - iam_assume_role_duration = 14400


10. iam_assume_role_session_name
- To specify name of the STS session to be assumed by Terragrunt prior to the connection
- Argument to define in terragrunt configuration file
- iam_assume_role_session_name = terragrunt