# ---------------------------------------------------------------------------------------------------------------------
# Required inputs
# These parameters must be specified.
# ---------------------------------------------------------------------------------------------------------------------
variable "workspace_organization" {
  description = "Terraform Cloud organization name."
  type        = string
}

variable "workspace_name" {
  description = "Terraform Cloud workspace name."
  type        = string
}

variable "tfe_oauth_token_id" {
  description = "Terraform Cloud <> VCS OAuth connection ID."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional inputs
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "enable" {
  description = "Enable this module. If set to false, no resources will be created."
  type        = bool
  default     = true
}

variable "workspace_description" {
  description = "Terraform Cloud workspace description."
  type        = string
  default     = null
}

variable "workspace_auto_apply" {
  description = "Auto apply changes (Continuous delivery)."
  type        = bool
  default     = false
}

variable "workspace_secrets" {
  description = "Secrets to add to the workspace. Provide a list of sensitive_inputs keys."
  type        = map(string)
  default     = {}
}

variable "workspace_hcl" {
  description = "Secrets to add to the workspace. Provide a list of sensitive_inputs keys."
  type        = map(string)
  default     = {}
}

variable "workspace_variables" {
  description = "Environment variables to add to the workspace. Provide a list of sensitive_inputs keys."
  type        = map(string)
  default     = {}
}

variable "vcs_repo_path" {
  description = "VCS repository path (<organization>/<repository>)."
  type        = string
}
variable "vcs_branch_name" {
  description = "VCS repository branch to track."
  type        = string
  default     = "main"
}
variable "vcs_working_directory" {
  description = "VCS repository branch to track."
  type        = string
  default     = ""
}

variable "sensitive_inputs" {
  description = "Pass sensitive inputs here"
  type        = map(string)
  sensitive   = true
  default     = {}
}
