# ---------------------------------------------------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------------------------------------------------
module "teams_vcs_github" {
  source = "../teams-github"
  enable = var.vcs_provider == "github"
  teams  = local.all_teams
}
