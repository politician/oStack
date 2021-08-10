# This configuration passes only the required variables in the most minimal configuration oStack can have
# Do not forget to add the files in ./common to use this configuration as is

# ---------------------------------------------------------------------------------------------------------------------
# oStack configuration
# ---------------------------------------------------------------------------------------------------------------------
module "oStack" {
  source  = "Olivr/oStack/oStack"
  version = "~> 1.0.0"

  # ---------------------------------------------------------------------------------------------------------------------
  # REQUIRED INPUTS
  # These parameters must be specified.
  # ---------------------------------------------------------------------------------------------------------------------
  organization_name      = var.organization_name
  cloud_default_provider = "linode"
  vcs_write_token        = var.vcs_write_token
  backend_configuration_base = {
    tfe = {
      tfe_oauth_token_id = var.tfe_oauth_token_id
    }
  }

  # ---------------------------------------------------------------------------------------------------------------------
  # OPTIONAL INPUTS
  # oStack provide reasonable defaults for these parameters.
  # ---------------------------------------------------------------------------------------------------------------------
  vcs_configuration_base = {
    github = {
      # Set to false to make it more convenient to experiment with oStack
      # Set back to true or delete this line/block for the long term
      repo_archive_on_destroy = true
    }
  }
}
