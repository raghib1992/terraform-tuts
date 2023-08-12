# Ref https://registry.terraform.io/providers/integrations/github/latest/docs

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {
    token = var.token
}

resource "github_repository" "example" {
  name        = "example"
  description = "My awesome codebase"
}