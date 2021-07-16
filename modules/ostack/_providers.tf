# ---------------------------------------------------------------------------------------------------------------------
# Providers
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  experiments      = [module_variable_optional_attrs]
  required_version = "~> 1.0"
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "0.1.10"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}

provider "github" {
  owner = local.vcs_organization_name
}
