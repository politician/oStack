locals {
  template_paths = distinct([for file in fileset("../templates", "[^.]**/*") : regex("[^/]+", file)])

  terraform_templates = { for path in local.template_paths :
    path => "ostack-${path}"
  }
}

// Create repos for Terraform modules
module "terraform_templates" {
  source   = "../modules/vcs-repo-github"
  for_each = local.terraform_templates

  repo_name = each.value
  repo_configuration = {
    description          = "Mirror of https://github.com/Olivr/oStack/tree/main/templates/${each.key}"
    website              = "https://oStack.io"
    repo_auto_init       = false
    repo_enable_issues   = false
    repo_enable_projects = false
    repo_enable_wikis    = false
    repo_is_template     = true
  }

  secrets = {
    copybara_ssh_key = null
    copybara_token   = null
  }

  sensitive_inputs = {
    copybara_ssh_key = tls_private_key.copybara_ssh_key.private_key_pem
    copybara_token   = var.github_token
  }
}
