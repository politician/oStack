# ---------------------------------------------------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------------------------------------------------
resource "github_repository_deploy_key" "deploy_keys" {
  for_each = var.enable ? var.deploy_keys : {}

  repository = local.repo.name
  title      = each.value.title
  key        = each.value.ssh_key != null ? each.value.ssh_key : var.sensitive_inputs["${each.key}_ssh_key"]
  read_only  = try(each.value.read_only, true)
}
