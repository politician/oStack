# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
variable "vcs_token" {
  description = "VCS token with write access"
  type        = string
}

variable "clusters" {
  description = "Clusters and their configuration"
  type = map(object({
    kube_host           = string
    kube_ca_certificate = string
    cluster_path        = string
    deploy_keys = map(object({
      name       = string
      namespace  = string
      public_key = string
    }))
  }))
}

variable "sensitive_inputs_per_cluster" {
  description = "Pass sensitive inputs here."
  type        = map(map(string))
  sensitive   = true
  default     = {}
}
