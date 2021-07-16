##
# Global
##

variable "organization_name" {
  description = "Organization name (eg. my-super-startup). \nUse only letters, numbers and dashes to maximize compatibility across every system."
  type        = string
  default     = null
  validation {
    condition     = var.organization_name == null || can(regex("^[\\w-]+$", var.organization_name))
    error_message = "Organization name must use only letters, numbers and dashes to maximize compatibility across every system."
  }
}

variable "namespace" {
  description = "Namespace name (a namespace contains several related projects). \nUse only letters, numbers and underscores to maximize compatibility across every system."
  type        = string

  validation {
    condition     = can(regex("^[\\w-]+$", var.namespace))
    error_message = "Namespace name must use only letters, numbers and underscores to maximize compatibility across every system."
  }
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}
