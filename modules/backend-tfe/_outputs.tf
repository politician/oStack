# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "ui_url" {
  description = "Management UI"
  value       = var.enable ? "https://app.terraform.io/app/${var.workspace_organization}/workspaces/${tfe_workspace.workspace[0].name}" : ""
}
