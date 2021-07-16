# ---------------------------------------------------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------------------------------------------------
module "clusters_backend_tfe" {
  source = "../backend-tfe"

  workspace_organization = local.backend_organization_name
  workspace_name         = local.clusters_repo.name
  workspace_description  = "Clusters infrastructure"
  workspace_auto_apply   = true
  workspace_secrets      = local.cluster_backend_secrets
  workspace_hcl          = local.clusters_backend_hcl

  vcs_repo_path         = local.clusters_repo.full_name
  vcs_branch_name       = local.clusters_repo.default_branch
  vcs_working_directory = "_infra"

  tfe_oauth_token_id = var.tfe_oauth_token_id
  sensitive_inputs   = local.clusters_backend_sensitive
}
