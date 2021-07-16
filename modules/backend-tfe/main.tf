# ---------------------------------------------------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------------------------------------------------
# Create workspace
resource "tfe_workspace" "workspace" {
  count = var.enable ? 1 : 0

  name              = var.workspace_name
  description       = var.workspace_description
  organization      = var.workspace_organization
  auto_apply        = var.workspace_auto_apply
  working_directory = var.vcs_working_directory
  vcs_repo {
    identifier     = var.vcs_repo_path
    branch         = var.vcs_branch_name
    oauth_token_id = var.tfe_oauth_token_id
  }
}

# Add secrets
resource "tfe_variable" "secrets" {
  for_each = var.enable ? var.workspace_secrets : {}

  workspace_id = tfe_workspace.workspace[0].id
  category     = "terraform"
  sensitive    = each.value == null
  key          = each.key
  value        = each.value != null ? each.value : var.sensitive_inputs[each.key]
}

# Add secrets in HCL format
resource "tfe_variable" "hcl" {
  for_each = var.enable ? var.workspace_hcl : {}

  workspace_id = tfe_workspace.workspace[0].id
  category     = "terraform"
  hcl          = true
  sensitive    = each.value == null
  key          = each.key
  value        = each.value != null ? each.value : var.sensitive_inputs[each.key]
}

# Add environment variables
resource "tfe_variable" "env_variables" {
  for_each = var.enable ? var.workspace_variables : {}

  workspace_id = tfe_workspace.workspace[0].id
  category     = "env"
  sensitive    = each.value == null
  key          = each.key
  value        = each.value != null ? each.value : var.sensitive_inputs[each.key]
}
