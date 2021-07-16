# ---------------------------------------------------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------------------------------------------------
resource "github_actions_secret" "secret" {
  for_each = var.enable ? var.secrets : {}

  repository      = local.repo.name
  secret_name     = each.key
  plaintext_value = each.value != null ? each.value : var.sensitive_inputs[each.key]
}
