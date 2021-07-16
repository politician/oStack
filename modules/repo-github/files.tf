# ---------------------------------------------------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------------------------------------------------
# If branch protection is enabled, track changes
resource "github_repository_file" "files" {
  for_each   = var.enable && var.branch_protection == false ? var.files : {}
  depends_on = [github_branch_protection.branch]

  repository          = local.repo.name
  branch              = local.repo.default_branch
  file                = each.key
  content             = each.value
  overwrite_on_create = true
}

# If branch protection is enabled, only commit before enabling and do not track changes
resource "github_repository_file" "initial_files" {
  for_each = var.enable && var.branch_protection ? var.files : {}

  repository          = local.repo.name
  branch              = local.repo.default_branch
  file                = each.key
  content             = each.value
  overwrite_on_create = true

  lifecycle {
    ignore_changes = all
  }
}
