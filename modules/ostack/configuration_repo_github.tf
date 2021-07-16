# ---------------------------------------------------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------------------------------------------------
module "configuration_repo_github" {
  source = "../repo-github"

  enable = var.vcs_provider == "github"
  count  = length(local.protected_files) > 0 ? 1 : 0

  name                 = "_configuration"
  auto_init            = true
  branch_protection    = false
  branch_review_count  = 0
  branch_status_checks = []
  description          = local.i18n.repo_configuration_description
  files                = local.protected_files
  has_issues           = false
  has_projects         = false
  has_wiki             = false
  issue_labels         = lookup(local.vcs_configuration_base, "repo_issue_labels", {})
  private              = lookup(local.vcs_configuration_base, "repo_private", null)
  team_permissions     = { admin = ["global_admin"] }
  teams                = local.teams_vcs.teams
  vulnerability_alerts = lookup(local.vcs_configuration_base, "repo_vulnerability_alerts", null)
}
