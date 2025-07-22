- terraform block helps terragrunt to communicate for resource management on target provider.
- with terraform block, it can find terraform configuration files ie. in github, gitlab, codecommit.
- define arguments that can be passed to terraform cli.
- define hooks(pre and post) to run before and after terraform.
- arguments for terraform blocks:
    - source
    - extra_arguments
    - hooks
    - include_in_cpoy
    - terragrunt-read-config
    - init-from-module-and-init

```hcl
terraform {
    source = git::git@github.com:raghib1992/terragrunt-aws-modules.git//modules/ec2-demo?ref=v1.0.1

    extra_arguments "custom_vars" {
        commands = [
            "apply",
            "plan",
            "refresh"
        ]
        required_vars_files = ["${get_parent_terragrunt_dir()}/common.tfvars"]
    }

    include_in_copy = [
        ".command_values.json",
        "*.yaml"
    ]

    before_hook "run_before_checks" {
        commands = ["apply", "plan"]
        execute  = ["echo", "lets execute before plan and apply hooks"]
    }

    after_hook "run_after_checks" {
        commands = ["apply", "plan"]
        execute  = ["echo", "lets execute after plan and apply hooks"]
        on_error = [
            ".*",
        ]
    }
}

```
