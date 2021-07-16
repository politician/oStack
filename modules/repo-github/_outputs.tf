# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "name" {
  description = "Repository name."
  value       = local.repo.name
}

output "full_name" {
  description = "Repository full name (with owner in path)."
  value       = local.repo.full_name
}

output "ui_url" {
  description = "URL to the repository on the web."
  value       = local.repo.html_url
}

output "default_branch" {
  description = "Default branch."
  value       = local.repo.default_branch
}
