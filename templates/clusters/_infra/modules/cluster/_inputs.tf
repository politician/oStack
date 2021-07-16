variable "deploy_keys" {
  description = "Deploy keys to add"
  type = map(object({
    name       = string
    namespace  = string
    public_key = string
  }))
}

variable "vcs_token" {
  description = "VCS token with write access"
  type        = string
  sensitive   = true
}

variable "cluster_path" {
  description = "Path to synchronize Flux with this cluster"
  type        = string
}

variable "sensitive_inputs" {
  description = "Pass sensitive inputs here."
  type        = map(string)
  sensitive   = true
  default     = {}
}
