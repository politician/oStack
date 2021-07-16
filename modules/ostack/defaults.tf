locals {
  ## Global

  organization_name = var.organization_name != null && var.organization_name != "" ? var.organization_name : lower(replace(replace(var.organization_title, " ", "-"), "/[^a-zA-Z0-9-]/", ""))


  ## VCS configuration

  # Use global organization name for VCS if it is not specified
  vcs_organization_name = var.vcs_organization_name != null && var.vcs_organization_name != "" ? var.vcs_organization_name : local.organization_name

  # Default VCS configuration used as a base for all repos unless some other configuration overwrites it
  default_vcs_config = {
    branch_default_name     = "main"
    branch_delete_on_merge  = true
    branch_protection       = true
    branch_review_count     = 0
    branch_status_checks    = []
    repo_allow_merge_commit = false
    repo_allow_rebase_merge = true
    repo_allow_squash_merge = true
    repo_enable_issues      = true
    repo_enable_projects    = true
    repo_enable_wikis       = true
    repo_issue_labels       = {}
    repo_private            = true
    repo_secrets            = {}
    tags                    = []
    file_templates = {
      codeowners_header = <<-EOT
      ##
      # ${local.i18n.file_template_header_1}
      # ${local.i18n.file_template_header_2}
      ##
      EOT
    }
  }

  # Overwrite default VCS configuration for any configuration parameter that is specified in vcs_configuration_base user input
  vcs_configuration_base = { for k, v in local.default_vcs_config :
    k => lookup(var.vcs_configuration_base, k, null) == null ? v : var.vcs_configuration_base[k]
  }


  ## Namespace configuration

  # If no namespace title was specified (default input value), use the organization title
  namespaces_with_titles = { for id, config in var.namespaces : id => merge(config, {
    title = lookup(config, "title", null) != null ? config.title : var.organization_title
    name  = lookup(config, "title", null) == null && lookup(config, "name", null) == null ? local.vcs_organization_name : lookup(config, "name", null)
  }) }

  # If no namespace name was specified, create it from the organization's title
  namespaces_with_names = { for id, config in local.namespaces_with_titles : id => merge(config, {
    name = lookup(config, "name", null) != null ? config.name : lower(replace(replace(config.title, " ", "-"), "/[^a-zA-Z0-9-]/", ""))
  }) }

  # Make sure each configuration parameter has a default value unless it is set in namespaces[*] user input
  namespaces_with_defaults = { for id, ns_config in local.namespaces_with_names :
    id => {
      title        = ns_config.title
      name         = ns_config.name
      description  = lookup(ns_config, "description", null) != null ? ns_config.description : format(local.i18n.ns_description, ns_config.title)
      environments = lookup(ns_config, "environments", null) != null ? ns_config.environments : keys(var.environments)

      # Use the following app configuration as default for any configuration parameter not set in namespaces[*].apps user input
      apps = { for key, default_value in merge(local.vcs_configuration_base, {
        continuous_delivery = true
        description         = format(local.i18n.repo_apps_description, ns_config.title)
        enabled             = true
        repo_name           = ns_config.name
        tags                = setunion(local.vcs_configuration_base.tags, [ns_config.title, local.i18n.global_applications, local.i18n.global_devops])
        repo_template       = "olivr/ostack-ns-apps",
        team_configuration = {
          admin    = ["global_admin"]
          maintain = ["global_manager", "${id}_manager", "global_apps_lead", "${id}_apps_lead"]
          read     = ["global_infra", "global_ops", "${id}_ops", "${id}_infra"]
          write    = ["global_apps", "${id}_apps"]
        }
        reviewers = {
          "*" = ["global_apps_lead", "${id}_apps_lead"]
        }
        }) :
        key => try(lookup(ns_config.apps, key, null), null) != null ? ns_config.apps[key] : default_value
      }

      # Use the following infra configuration as default for any configuration parameter not set in namespaces[*].infra user input
      infra = { for key, default_value in merge(local.vcs_configuration_base, {
        continuous_delivery  = true
        description          = format(local.i18n.repo_infrastructure_description, ns_config.title)
        enabled              = true
        repo_name            = "${ns_config.name}-infra"
        backend_secrets      = {}
        tags                 = setunion(local.vcs_configuration_base.tags, [ns_config.title, local.i18n.global_infrastructure, local.i18n.global_iac])
        branch_status_checks = ["Terraform Cloud/${local.backend_organization_name}/${ns_config.name}-infra"]
        repo_template        = "olivr/ostack-ns-infra",
        team_configuration = {
          admin    = ["global_admin"]
          maintain = ["global_manager", "${id}_manager", "global_infra_lead", "${id}_infra_lead"]
          read     = ["global_ops", "global_apps", "${id}_ops", "${id}_apps"]
          write    = ["global_infra", "${id}_infra"]
        }
        reviewers = {
          "*" = ["global_infra_lead", "${id}_infra_lead"]
        }
        }) :
        key => try(lookup(ns_config.infra, key, null), null) != null ? ns_config.infra[key] : default_value
      }

      # Use the following ops configuration as default for any configuration parameter not set in namespaces[*].ops user input
      ops = { for key, default_value in merge(local.vcs_configuration_base, {
        continuous_delivery = true
        description         = format(local.i18n.repo_operations_description, ns_config.title)
        enabled             = true
        repo_name           = "${ns_config.name}-ops"
        tags                = setunion(local.vcs_configuration_base.tags, [ns_config.title, local.i18n.global_operations, local.i18n.global_gitops])
        repo_template       = "olivr/ostack-ns-ops",
        team_configuration = {
          admin    = ["global_admin"]
          maintain = ["global_manager", "${id}_manager"]
          read     = ["global_infra", "global_apps", "${id}_apps", "${id}_infra"]
          write    = ["global_ops", "${id}_ops"]
        }
        files = merge({
          "_base/kustomization.yaml" = file("${path.module}/templates/ops/_base/kustomization.yaml")
          "_base/delete-me.yaml" = templatefile("${path.module}/templates/ops/_base/delete-me.yaml", {
            namespace = ns_config.name
          })
          }, { for env in(lookup(ns_config, "environments", null) != null ? ns_config.environments : keys(var.environments)) :
          "${env}/kustomization.yaml" => file("${path.module}/templates/ops/env/kustomization.yaml")
        })
        reviewers = { for env in(lookup(ns_config, "environments", null) != null ? ns_config.environments : keys(var.environments)) :
          "/${env}/**" => ["global_ops_${env}", "${id}_ops_${env}"]
        }
        }) :
        key => try(lookup(ns_config.ops, key, null), null) != null ? ns_config.ops[key] : default_value
      }
    }
  }

  namespaces = { for id, ns_config in local.namespaces_with_defaults :
    id => merge(ns_config, {
      apps = merge(ns_config.apps, {
        repo_secrets = merge(ns_config.apps.repo_secrets, {
          # organization_name = local.organization_name
          # namespace_name    = ns_config.name
        })
      })
      infra = merge(ns_config.infra, {
        repo_secrets = merge(ns_config.infra.repo_secrets, {
          # organization_name = local.organization_name
          # namespace_name    = ns_config.name
        })
        backend_secrets = merge(ns_config.infra.backend_secrets, {
          # organization_name = local.organization_name
          # namespace_name    = ns_config.name
        })
      })
      ops = merge(ns_config.ops, {
        repo_secrets = merge(ns_config.ops.repo_secrets, {
          # organization_name = local.organization_name
          # namespace_name    = ns_config.name
        })
      })
    })
  }


  ##
  # Environments defaults
  ##

  # Default cluster configuration for each environment
  # TODO: Automatically update default Linode Kubernetes version on schedule
  default_cluster_config = {
    sensitive_kube_config = null
    kube_version          = "1.21"
    nodes                 = { "g6-standard-1" = 1 }
    region                = "us-central"
  }

  # Make sure each environment has default values set for every configuration parameter
  # TODO: don't add cluster configuration if sensitive_kube_config is set
  environments = { for env, configs in var.environments :
    env => length(configs) > 0 ? [for config in configs : { for key, default_value in local.default_cluster_config :
      key => lookup(config, key, null) != null ? config[key] : default_value
    }] : [local.default_cluster_config]
  }

  ##
  # Infrastructure backend
  ##
  backend_organization_name = var.backend_organization_name != null && var.backend_organization_name != "" ? var.backend_organization_name : local.organization_name
}
