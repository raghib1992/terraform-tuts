- remote state add remote state configuration for our terraform code
- For example, we can add remote state storage for aws target provider  to store  terraform stae file in s3 bucket form terragrunt config file with "remote_state" block
- To update/add backend resource block in terraform config file, we sue to generate block which will create a file to add backend resource block in the working directory.
- We can add some blocks to multiple modules  with the help of "find_in_the_parent_folder()"to pull settings.
- remote_state block adds remote state and locking resoure for terraform. FOr example. AWS with s3 bucket for remote state and DynamoDB for state locking.
- Terragrunt can control s3 backend as per requirement with config sub block. FOr Example, if we need versioning to be enable which is not enabled on bucket by default and terragrunt will do the job for you.
- Arguments
     - backend
     - diable_init
     - disbale_dependencies_optimization
     - generate
     - config