## VCS token with write access
variable "github_token" {
  description = "GitHub token."
  type        = string
  sensitive   = true
}
