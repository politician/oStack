# ---------------------------------------------------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------------------------------------------------
module "ns_repos_github" {
  source = "../repo-github"

  enable   = var.vcs_provider == "github"
  for_each = local.repos_with_files

  name                             = each.value.repo_name
  allow_merge_commit               = lookup(each.value, "repo_allow_merge_commit", null)
  allow_rebase_merge               = lookup(each.value, "repo_allow_rebase_merge", null)
  allow_squash_merge               = lookup(each.value, "repo_allow_squash_merge", null)
  archive_on_destroy               = lookup(each.value, "repo_archive_on_destroy", null)
  auto_init                        = lookup(each.value, "repo_auto_init", null)
  branch_delete_on_merge           = lookup(each.value, "branch_delete_on_merge", null)
  branch_protection                = lookup(each.value, "branch_protection", null)
  branch_protection_enforce_admins = lookup(each.value, "branch_protection_enforce_admins", null)
  branch_review_count              = lookup(each.value, "branch_review_count", null)
  branch_status_checks             = lookup(each.value, "branch_status_checks", [])
  deploy_keys                      = lookup(each.value, "deploy_keys", {})
  description                      = lookup(each.value, "description", null)
  files                            = lookup(each.value, "files", {})
  has_issues                       = lookup(each.value, "repo_enable_issues", null)
  has_projects                     = lookup(each.value, "repo_enable_projects", null)
  has_wiki                         = lookup(each.value, "repo_enable_wikis", null)
  homepage_url                     = lookup(each.value, "website", null)
  is_template                      = lookup(each.value, "repo_is_template", null)
  issue_labels                     = lookup(each.value, "repo_issue_labels", {})
  private                          = lookup(each.value, "repo_private", null)
  secrets                          = lookup(each.value, "repo_secrets", {})
  sensitive_inputs                 = lookup(local.ns_repos_sensitive_inputs, each.key, {})
  teams                            = local.teams_vcs.teams
  template                         = lookup(each.value, "repo_template", null)
  topics                           = lookup(each.value, "tags", null)
  vulnerability_alerts             = lookup(each.value, "repo_vulnerability_alerts", null)
  team_permissions = {
    pull     = each.value.team_configuration.read
    triage   = []
    push     = each.value.team_configuration.write
    maintain = each.value.team_configuration.maintain
    admin    = each.value.team_configuration.admin
  }
}
