# ---------------------------------------------------------------------------------------------------------------------
# Required inputs
# These parameters must be specified.
# ---------------------------------------------------------------------------------------------------------------------
variable "teams" {
  description = "GitHub teams and their configuration."
  type = map(object({
    name        = string
    description = optional(string)
    privacy     = optional(string)
    teams = optional(map(object({
      name        = string
      description = optional(string)
      privacy     = optional(string)
      teams = optional(map(object({
        name        = string
        description = optional(string)
        privacy     = optional(string)
        members = optional(set(object({
          user = string,
          role = string
        })))
      })))
      members = optional(set(object({
        user = string,
        role = string
      })))
    })))
    members = optional(set(object({
      user = string,
      role = string
    })))
  }))
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
