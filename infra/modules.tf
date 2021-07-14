locals {
  module_paths = distinct([for file in fileset("../modules", "[^.]**/*") : regex("[^/]+", file)])

  terraform_modules = { for path in local.module_paths :
    path => {
      repo   = path == "ostack" ? "terraform-github-oStack" : replace(path, "/^(.+)-([^-]+)$/", "terraform-$2-$1")
      source = path == "ostack" ? "Olivr/oStack/github" : replace(path, "/^(.+)-([^-]+)$/", "Olivr/$1/$2")
    }
  }
}

// Create repos for Terraform modules
module "terraform_modules" {
  source   = "../modules/vcs-repo-github"
  for_each = local.terraform_modules

  repo_name = each.value.repo
  repo_configuration = {
    description          = "Mirror of https://github.com/Olivr/oStack/tree/main/modules/${each.key}"
    website              = "https://oStack.io"
    repo_auto_init       = false
    repo_enable_issues   = false
    repo_enable_projects = false
    repo_enable_wikis    = false
  }

  secrets = {
    copybara_ssh_key = null
    copybara_token   = null
    # module_path      = each.key
    # module_source    = each.value.source
  }

  sensitive_inputs = {
    copybara_ssh_key = tls_private_key.copybara_ssh_key.private_key_pem
    copybara_token   = var.github_token
  }
}
