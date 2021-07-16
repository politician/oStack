# ---------------------------------------------------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------------------------------------------------
module "clusters_repo_github" {
  source = "../repo-github"

  enable = var.vcs_provider == "github"

  name                 = "_clusters"
  branch_protection    = false # REMOVE THAT and merge cluster_files to protected_files
  branch_review_count  = 0
  branch_status_checks = []
  deploy_keys          = local.cluster_deploy_keys
  description          = local.i18n.repo_clusters_description
  files                = local.clusters_files
  private              = lookup(local.vcs_configuration_base, "repo_private", true)
  sensitive_inputs     = local.clusters_sensitive_inputs
  teams                = local.teams_vcs.teams
  template             = "olivr/ostack-clusters"
  topics = setunion(local.vcs_configuration_base.tags, [
    local.i18n.global_infrastructure,
    local.i18n.global_iac,
    local.i18n.global_operations,
    local.i18n.global_gitops
  ])
  team_permissions = {
    admin    = ["global_admin"]
    maintain = ["global_manager", "global_infra_lead"]
    write    = ["global_ops", "global_infra"]
  }
}
