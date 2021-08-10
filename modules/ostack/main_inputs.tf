# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED INPUTS
# These parameters must be specified.
# ---------------------------------------------------------------------------------------------------------------------
# Global
variable "organization_name" {
  description = <<-DESC
    Computer-friendly organization name (eg. my-startup).
    Use only letters, numbers and dashes to maximize compatibility across every system.
    DESC
  type        = string

  validation {
    error_message = "Organization name must only contain alphanumeric characters. It may contain '-' but cannot start or finish with it."
    condition     = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?([a-zA-Z0-9]([-a-zA-Z0-9]*[a-zA-Z0-9])?)*$", var.organization_name))
  }
}

# variable "certificate_email" {
#   description = "Email address used for generating certificates."
#   type        = string

#   validation {
#     error_message = "Variable lang cannot be null."
#     condition     = var.certificate_email != null
#   }

#   validation {
#     error_message = "You must enter a real email address."
#     condition     = can(regex("^\\S+@\\S+\\.\\S+$", var.certificate_email))
#   }
# }

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL INPUTS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
# Global
variable "organization_title" {
  description = "Human-friendly organization title (eg. My Startup)."
  type        = string
  default     = null
}

variable "lang" {
  description = <<-DESC
    Translation file to use. This can be one of the bundled translations of oStack or a custom translation object.
    This can be used to overwrite how things are called throughout your stack.
    DESC
  type        = any
  default     = "en"

  validation {
    error_message = "Variable lang cannot be null."
    condition     = var.lang != null
  }

  validation {
    error_message = "You must specify a supported language or provide your own."
    condition     = contains(["en", "fr"], var.lang) || try(length(keys(var.lang)), 0) > 0
  }
}

variable "prefix" {
  description = "Prefix to prepend to all generated resource names. It is not applied wherever you specify resource names explicitly."
  type        = string
  default     = ""

  validation {
    error_message = "Variable prefix cannot be null."
    condition     = var.prefix != null
  }
}

variable "tags" {
  description = "Tags to be applied to all resources that support it. It is not applied wherever you specify resource tags explicitly."
  type        = set(string)
  default     = ["oStack"]

  validation {
    error_message = "Variable tags cannot be null."
    condition     = var.tags != null
  }
}

variable "sensitive_inputs" {
  description = <<-DESC
    Values that should be marked as sensitive.
    Supported by `repo_secrets` (vcs), `env_vars` (backend), `tf_vars` (backend), `tf_vars_hcl` (backend), `kube_config` (cluster).
    DESC
  type        = map(string)
  sensitive   = true
  default     = {}

  validation {
    error_message = "Variable sensitive_inputs cannot be null."
    condition     = var.sensitive_inputs != null
  }

  validation {
    error_message = "Null values are not accepted. Use empty values instead."
    condition     = alltrue([for v in values(var.sensitive_inputs) : v != null])
  }
}

variable "continuous_delivery" {
  description = "Should continuous delivery be applied by default. This applies to all aspects of the stack (devops, gitops, iac)."
  type        = bool
  default     = true

  validation {
    error_message = "Variable continuous_delivery cannot be null."
    condition     = var.continuous_delivery != null
  }
}

variable "globalinfra_vcs_repo_name" {
  description = <<-DESC
    Name of the global infra repo so that oStack can apply its settings to it (eg. branch protection, team access)
    It must be created already on the default VCS provider.
    Set to `null` if you don't want oStack to manage this repo at all.
    DESC
  type        = string
  default     = null
}

variable "globalinfra_backend_workspace_name" {
  description = <<-DESC
    Name of the global infra backend workspace name so that oStack can propagate backend runs.
    This is used because Terraform Cloud won't trigger a run when variables values change, but oStack needs to in order to keep the configuration up to date!
    It must be created already on the default backend provider.
    Set to `null` if you don't want runs to propagate.
    DESC
  type        = string
  default     = null
}
