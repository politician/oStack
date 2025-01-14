# ---------------------------------------------------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------------------------------------------------
module "vcs_teams_github" {
  source = "../teams-github"

  for_each = local.vcs_teams_github

  teams = local.teams
}

module "vcs_repos_namespaces_github" {
  source = "../repo-github"

  for_each = local.vcs_repos_namespaces_github

  allow_merge_commit               = each.value.vcs.repo_allow_merge_commit
  allow_rebase_merge               = each.value.vcs.repo_allow_rebase_merge
  allow_squash_merge               = each.value.vcs.repo_allow_squash_merge
  archive_on_destroy               = each.value.vcs.repo_archive_on_destroy
  auto_init                        = each.value.vcs.repo_auto_init
  branch_delete_on_merge           = each.value.vcs.branch_delete_on_merge
  branch_protection                = each.value.vcs.branch_protection
  branch_protection_enforce_admins = each.value.vcs.branch_protection_enforce_admins
  branch_review_count              = each.value.vcs.branch_review_count
  branch_status_checks             = each.value.vcs.branch_status_checks
  deploy_keys                      = local.namespaces_repos_dynamic[each.key].deploy_keys
  description                      = each.value.description
  files                            = local.namespaces_repos_dynamic[each.key].files
  files_strict                     = local.namespaces_repos_dynamic[each.key].files_strict
  has_issues                       = each.value.vcs.repo_enable_issues
  has_projects                     = each.value.vcs.repo_enable_projects
  has_wiki                         = each.value.vcs.repo_enable_wikis
  homepage_url                     = each.value.vcs.repo_homepage_url
  is_template                      = each.value.vcs.repo_is_template
  issue_labels                     = each.value.vcs.repo_issue_labels
  name                             = each.value.name
  private                          = each.value.vcs.repo_private
  repo_exists                      = !each.value.vcs.create
  secrets                          = each.value.vcs.repo_secrets
  sensitive_inputs                 = each.value.vcs.sensitive_inputs
  teams                            = module.vcs_teams_github["github"].teams
  template                         = each.value.vcs.repo_template
  topics                           = each.value.vcs.tags
  vulnerability_alerts             = each.value.vcs.repo_vulnerability_alerts
  team_permissions = {
    admin    = each.value.vcs.team_configuration.admin
    maintain = each.value.vcs.team_configuration.maintain
    pull     = each.value.vcs.team_configuration.read
    push     = each.value.vcs.team_configuration.write
    triage   = []
  }
}

module "vcs_repo_globalinfra_github" {
  source = "../repo-github"

  for_each = local.vcs_repo_globalinfra_github

  allow_merge_commit               = local.globalinfra.vcs.repo_allow_merge_commit
  allow_rebase_merge               = local.globalinfra.vcs.repo_allow_rebase_merge
  allow_squash_merge               = local.globalinfra.vcs.repo_allow_squash_merge
  archive_on_destroy               = local.globalinfra.vcs.repo_archive_on_destroy
  auto_init                        = local.globalinfra.vcs.repo_auto_init
  branch_delete_on_merge           = local.globalinfra.vcs.branch_delete_on_merge
  branch_protection                = local.globalinfra.vcs.branch_protection
  branch_protection_enforce_admins = local.globalinfra.vcs.branch_protection_enforce_admins
  branch_review_count              = local.globalinfra.vcs.branch_review_count
  branch_status_checks             = local.globalinfra.vcs.branch_status_checks
  deploy_keys                      = local.globalinfra.vcs.deploy_keys
  description                      = local.globalinfra.description
  files                            = local.globalinfra.vcs.files
  files_strict                     = local.globalinfra.vcs.files_strict
  has_issues                       = local.globalinfra.vcs.repo_enable_issues
  has_projects                     = local.globalinfra.vcs.repo_enable_projects
  has_wiki                         = local.globalinfra.vcs.repo_enable_wikis
  homepage_url                     = local.globalinfra.vcs.repo_homepage_url
  is_template                      = local.globalinfra.vcs.repo_is_template
  issue_labels                     = local.globalinfra.vcs.repo_issue_labels
  name                             = local.globalinfra.name
  private                          = local.globalinfra.vcs.repo_private
  repo_exists                      = local.globalinfra.vcs.repo_exists
  secrets                          = local.globalinfra.vcs.repo_secrets
  sensitive_inputs                 = local.globalinfra.vcs.sensitive_inputs
  teams                            = module.vcs_teams_github["github"].teams
  template                         = local.globalinfra.vcs.repo_template
  topics                           = local.globalinfra.vcs.tags
  vulnerability_alerts             = local.globalinfra.vcs.repo_vulnerability_alerts
  team_permissions = {
    admin    = local.globalinfra.vcs.team_configuration.admin
    maintain = local.globalinfra.vcs.team_configuration.maintain
    pull     = local.globalinfra.vcs.team_configuration.read
    push     = local.globalinfra.vcs.team_configuration.write
    triage   = []
  }
}

module "vcs_repo_globalops_github" {
  source = "../repo-github"

  for_each = local.vcs_repo_globalops_github

  allow_merge_commit               = local.globalops.vcs.repo_allow_merge_commit
  allow_rebase_merge               = local.globalops.vcs.repo_allow_rebase_merge
  allow_squash_merge               = local.globalops.vcs.repo_allow_squash_merge
  archive_on_destroy               = local.globalops.vcs.repo_archive_on_destroy
  auto_init                        = local.globalops.vcs.repo_auto_init
  branch_delete_on_merge           = local.globalops.vcs.branch_delete_on_merge
  branch_protection                = local.globalops.vcs.branch_protection
  branch_protection_enforce_admins = local.globalops.vcs.branch_protection_enforce_admins
  branch_review_count              = local.globalops.vcs.branch_review_count
  branch_status_checks             = local.globalops.vcs.branch_status_checks
  deploy_keys                      = local.globalops.vcs.deploy_keys
  description                      = local.globalops.description
  files                            = local.globalops.vcs.files
  files_strict                     = local.globalops.vcs.files_strict
  has_issues                       = local.globalops.vcs.repo_enable_issues
  has_projects                     = local.globalops.vcs.repo_enable_projects
  has_wiki                         = local.globalops.vcs.repo_enable_wikis
  homepage_url                     = local.globalops.vcs.repo_homepage_url
  is_template                      = local.globalops.vcs.repo_is_template
  issue_labels                     = local.globalops.vcs.repo_issue_labels
  name                             = local.globalops.name
  private                          = local.globalops.vcs.repo_private
  secrets                          = local.globalops.vcs.repo_secrets
  sensitive_inputs                 = local.globalops.vcs.sensitive_inputs
  teams                            = module.vcs_teams_github["github"].teams
  template                         = local.globalops.vcs.repo_template
  topics                           = local.globalops.vcs.tags
  vulnerability_alerts             = local.globalops.vcs.repo_vulnerability_alerts
  team_permissions = {
    admin    = local.globalops.vcs.team_configuration.admin
    maintain = local.globalops.vcs.team_configuration.maintain
    pull     = local.globalops.vcs.team_configuration.read
    push     = local.globalops.vcs.team_configuration.write
    triage   = []
  }
}

module "vcs_repo_globalconfig_github" {
  source = "../repo-github"

  for_each = local.vcs_repo_globalconfig_github
  depends_on = [
    module.vcs_repo_globalops_github,
    module.vcs_repos_namespaces_github,
    local.backends_namespaces,
    local.backends_globalops
  ]

  allow_merge_commit               = each.value.vcs.repo_allow_merge_commit
  allow_rebase_merge               = each.value.vcs.repo_allow_rebase_merge
  allow_squash_merge               = each.value.vcs.repo_allow_squash_merge
  archive_on_destroy               = each.value.vcs.repo_archive_on_destroy
  auto_init                        = each.value.vcs.repo_auto_init
  branch_delete_on_merge           = each.value.vcs.branch_delete_on_merge
  branch_protection                = each.value.vcs.branch_protection
  branch_protection_enforce_admins = each.value.vcs.branch_protection_enforce_admins
  branch_review_count              = each.value.vcs.branch_review_count
  branch_status_checks             = each.value.vcs.branch_status_checks
  deploy_keys                      = each.value.vcs.deploy_keys
  description                      = each.value.description
  dotfiles_first                   = true
  files                            = local.globalconfig[each.key].vcs.files
  files_strict                     = local.globalconfig[each.key].vcs.files_strict
  has_issues                       = each.value.vcs.repo_enable_issues
  has_projects                     = each.value.vcs.repo_enable_projects
  has_wiki                         = each.value.vcs.repo_enable_wikis
  homepage_url                     = each.value.vcs.repo_homepage_url
  is_template                      = each.value.vcs.repo_is_template
  issue_labels                     = each.value.vcs.repo_issue_labels
  name                             = each.value.name
  private                          = each.value.vcs.repo_private
  secrets                          = each.value.vcs.repo_secrets
  sensitive_inputs                 = each.value.vcs.sensitive_inputs
  teams                            = module.vcs_teams_github["github"].teams
  template                         = each.value.vcs.repo_template
  topics                           = each.value.vcs.tags
  vulnerability_alerts             = each.value.vcs.repo_vulnerability_alerts
  team_permissions = {
    admin    = each.value.vcs.team_configuration.admin
    maintain = each.value.vcs.team_configuration.maintain
    pull     = each.value.vcs.team_configuration.read
    push     = each.value.vcs.team_configuration.write
    triage   = []
  }
}
