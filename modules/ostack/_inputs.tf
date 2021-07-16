# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED INPUTS
# These parameters must be specified.
# ---------------------------------------------------------------------------------------------------------------------

# Global
variable "organization_title" {
  description = "Organization title (eg. My Super Startup)."
  type        = string
  validation {
    condition     = var.organization_title != null && var.organization_title != ""
    error_message = "You must specify a title for your organization."
  }
}

# Infrastructure backend
variable "tfe_oauth_token_id" {
  description = "VCS OAuth connection ID. https://www.terraform.io/docs/cloud/vcs/index.html"
  type        = string
}


# VCS token with write access
variable "vcs_token_write" {
  description = "VCS token."
  type        = string
  sensitive   = true
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL INPUTS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

# Global
variable "organization_name" {
  description = "Organization name (eg. my-super-startup). \nUse only letters, numbers and dashes to maximize compatibility across every system."
  type        = string
  default     = null
  validation {
    condition     = var.organization_name == null || can(regex("^[\\w-]+$", var.organization_name))
    error_message = "Organization name must use only letters, numbers and dashes to maximize compatibility across every system."
  }
}

variable "lang" {
  description = "Translation file to use. This can be one of the bundled translations of oStack or a custom translation object. \nThis can be used to overwrite how things are called through your stack."
  type        = any
  default     = "en"
  validation {
    condition     = contains(["en", "fr"], var.lang) || try(length(keys(var.lang)), 0) > 0
    error_message = "You must specify a supported language or provide your own."
  }
}

variable "namespaces" {
  description = "Namespaces and their optional configuration. \nA namespace can be a project or a group of projects (if using a monorepo structure).\nBy default a namespace bearing the same name as your organization will be created. \nIf you want to later rename your namespaces, do not change the key name or Terraform will destroy it and create a new one from scratch. As such it is recommended to use generic key names such as ns1, ns2."
  type = map(object({
    title        = string
    name         = optional(string)
    description  = optional(string)
    environments = optional(list(string))
    infra = optional(object({
      branch_default_name     = optional(string)
      branch_delete_on_merge  = optional(bool)
      branch_protection       = optional(bool)
      branch_review_count     = optional(number)
      branch_status_checks    = optional(list(string))
      continuous_delivery     = optional(bool)
      description             = optional(string)
      enabled                 = optional(bool)
      repo_allow_merge_commit = optional(bool)
      repo_allow_rebase_merge = optional(bool)
      repo_allow_squash_merge = optional(bool)
      repo_enable_issues      = optional(bool)
      repo_enable_projects    = optional(bool)
      repo_enable_wikis       = optional(bool)
      repo_issue_labels       = optional(map(string))
      repo_name               = optional(string)
      repo_private            = optional(bool)
      backend_secrets         = optional(map(string))
      repo_secrets            = optional(map(string))
      repo_template           = optional(string)
      tags                    = optional(set(string))
      file_templates = optional(object({
        codeowners_header = optional(string)
        codeowners_footer = optional(string)
      }))
    }))
    ops = optional(object({
      branch_default_name     = optional(string)
      branch_delete_on_merge  = optional(bool)
      branch_protection       = optional(bool)
      branch_review_count     = optional(number)
      branch_status_checks    = optional(list(string))
      continuous_delivery     = optional(bool)
      description             = optional(string)
      enabled                 = optional(bool)
      repo_allow_merge_commit = optional(bool)
      repo_allow_rebase_merge = optional(bool)
      repo_allow_squash_merge = optional(bool)
      repo_enable_issues      = optional(bool)
      repo_enable_projects    = optional(bool)
      repo_enable_wikis       = optional(bool)
      repo_issue_labels       = optional(map(string))
      repo_name               = optional(string)
      repo_private            = optional(bool)
      repo_secrets            = optional(map(string))
      repo_template           = optional(string)
      tags                    = optional(set(string))
      file_templates = optional(object({
        codeowners_header = optional(string)
        codeowners_footer = optional(string)
      }))
    }))
    apps = optional(object({
      branch_default_name     = optional(string)
      branch_delete_on_merge  = optional(bool)
      branch_protection       = optional(bool)
      branch_review_count     = optional(number)
      branch_status_checks    = optional(list(string))
      continuous_delivery     = optional(bool)
      description             = optional(string)
      enabled                 = optional(bool)
      repo_allow_merge_commit = optional(bool)
      repo_allow_rebase_merge = optional(bool)
      repo_allow_squash_merge = optional(bool)
      repo_enable_issues      = optional(bool)
      repo_enable_projects    = optional(bool)
      repo_enable_wikis       = optional(bool)
      repo_issue_labels       = optional(map(string))
      repo_name               = optional(string)
      repo_private            = optional(bool)
      repo_secrets            = optional(map(string))
      repo_template           = optional(string)
      tags                    = optional(set(string))
      file_templates = optional(object({
        codeowners_header = optional(string)
        codeowners_footer = optional(string)
      }))
    }))
  }))
  default = { ns1 = { title = null } }
  validation {
    condition     = var.namespaces != null && alltrue([for key, config in var.namespaces : (config.title == null || config.title == "") && key != "ns1" ? false : true])
    error_message = "You must specify at least one namespace and its title."
  }
}

variable "environments" {
  description = "Environment names and their optional cluster configuration. \nNote that all namespaces are assigned to all clusters unless the `namespaces` parameter is set."
  type = map(list(object({
    region                = optional(string)
    nodes                 = optional(map(number))
    kube_version          = optional(string)
    sensitive_kube_config = optional(string)
  })))
  default = { staging = [] }
  validation {
    condition     = try(length(keys(var.environments)), 0) != 0
    error_message = "You must specify at least one environment."
  }
}

# Infrastructure backend
variable "backend_provider" {
  description = "Backend provider."
  type        = string
  default     = "tfe"
  validation {
    condition     = contains(["tfe"], var.backend_provider)
    error_message = "You must specify a supported backend provider."
  }
}

variable "backend_organization_name" {
  description = "Backend organization name."
  type        = string
  default     = null
}

# Version Control System
variable "vcs_provider" {
  description = "VCS provider."
  type        = string
  default     = "github"
  validation {
    condition     = contains(["github"], var.vcs_provider)
    error_message = "You must specify a supported VCS provider."
  }
}

variable "vcs_organization_name" {
  description = "VCS Organization name."
  type        = string
  default     = null
}

variable "vcs_configuration_base" {
  description = "Base configuration for the VCS."
  type = object({
    branch_default_name     = optional(string)
    branch_delete_on_merge  = optional(bool)
    branch_protection       = optional(bool)
    branch_review_count     = optional(number)
    branch_status_checks    = optional(list(string))
    repo_allow_merge_commit = optional(bool)
    repo_allow_rebase_merge = optional(bool)
    repo_allow_squash_merge = optional(bool)
    repo_enable_issues      = optional(bool)
    repo_enable_projects    = optional(bool)
    repo_enable_wikis       = optional(bool)
    repo_issue_labels       = optional(map(string))
    repo_private            = optional(bool)
    repo_secrets            = optional(map(string))
    repo_template           = optional(string)
    tags                    = optional(set(string))
    file_templates = optional(object({
      codeowners_header = optional(string)
      codeowners_footer = optional(string)
    }))
  })
  default = {}
}
# "Map of GitHub issue labels and their colors to add to the repository. \nIn the format { \"label\" = \"#FFFFFF\" }"

variable "vcs_automation_user_name" {
  description = "VCS username associated with the token used for automation.\nDefaults to current user."
  type        = string
  default     = ""
}

variable "sensitive_inputs" {
  description = "Pass sensitive inputs here"
  type        = map(string)
  sensitive   = true
  default     = {}
}
