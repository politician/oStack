terraform {
  experiments = [module_variable_optional_attrs]
}


terraform {
  required_version = ">= 0.15"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.20.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.21.0"
    }
  }
}
