# ---------------------------------------------------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------------------------------------------------
module "ns_backends_tfe" {
  source = "../backend-tfe"

  enable   = var.backend_provider == "tfe"
  for_each = local.ns_backends_to_create

  workspace_organization = local.backend_organization_name
  workspace_name         = each.value.repo_name
  workspace_description  = each.value.description
  workspace_auto_apply   = each.value.continuous_delivery
  workspace_secrets      = each.value.backend_secrets

  vcs_repo_path   = local.ns_repos[each.key].full_name
  vcs_branch_name = each.value.branch_default_name

  tfe_oauth_token_id = var.tfe_oauth_token_id
  sensitive_inputs   = { for k, v in var.sensitive_inputs : k => v if contains(keys(each.value.backend_secrets), k) }
}
