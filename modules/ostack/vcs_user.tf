# Detect VCS automation username.
# Should be in its own module but is overkill as long as GitHub is the only VCS supported by oStack.
data "github_user" "current" {
  username = var.vcs_automation_user_name
}

locals {
  vcs_automation_user_name = data.github_user.current.login
}
