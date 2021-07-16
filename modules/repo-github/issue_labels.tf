# ---------------------------------------------------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------------------------------------------------
resource "github_issue_label" "labels" {
  for_each = var.enable ? var.issue_labels : {}

  repository = local.repo.name
  name       = each.key
  color      = each.value
}
