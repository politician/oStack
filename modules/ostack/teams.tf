# Teams are used to manage access rights without being dependant on the number of users

# ---------------------------------------------------------------------------------------------------------------------
# Computations
# ---------------------------------------------------------------------------------------------------------------------
# Global teams
locals {
  global_teams = {
    global = {
      name        = local.i18n.team_global_name
      description = local.i18n.team_global_description
      teams = {
        global_admin = {
          name        = local.i18n.team_global_admin_name
          description = local.i18n.team_global_admin_description
          members     = [{ user = local.vcs_automation_user_name, role = "maintainer" }]
        },
        global_manager = {
          name        = local.i18n.team_global_manager_name
          description = local.i18n.team_global_manager_description
        },
        global_infra = {
          name        = local.i18n.team_global_infra_name
          description = local.i18n.team_global_infra_description
          teams = {
            global_infra_lead = {
              name        = local.i18n.team_global_infra_lead_name
              description = local.i18n.team_global_infra_lead_description
            }
          }
        },
        global_ops = {
          name        = local.i18n.team_global_ops_name
          description = local.i18n.team_global_ops_description
          teams = { for env in keys(local.environments) : "global_ops_${env}" => {
            name        = format(local.i18n.team_global_ops_env_name, title(env))
            description = format(local.i18n.team_global_ops_env_description, title(env))
          } }
        },
        global_apps = {
          name        = local.i18n.team_global_apps_name
          description = local.i18n.team_global_apps_description
          teams = {
            global_apps_lead = {
              name        = local.i18n.team_global_apps_lead_name
              description = local.i18n.team_global_apps_lead_description
            }
          }
        },
      }
    },
  }

  # Namespace-specific teams
  namespace_teams = merge([for id, config in local.namespaces :
    {
      "${id}" = {
        name        = format(local.i18n.team_ns_name, config.title)
        description = format(local.i18n.team_ns_description, config.title)
        teams = {
          "${id}_manager" = {
            name        = format(local.i18n.team_ns_manager_name, config.title)
            description = format(local.i18n.team_ns_manager_description, config.title)
          },
          "${id}_infra" = {
            name        = format(local.i18n.team_ns_infra_name, config.title)
            description = format(local.i18n.team_ns_infra_description, config.title)
            teams = {
              "${id}_infra_lead" = {
                name        = format(local.i18n.team_ns_infra_lead_name, config.title)
                description = format(local.i18n.team_ns_infra_lead_description, config.title)
              }
            }
          },
          "${id}_ops" = {
            name        = format(local.i18n.team_ns_ops_name, config.title)
            description = format(local.i18n.team_ns_ops_description, config.title)
            teams = { for env in keys(local.environments) : "${id}_ops_${env}" => {
              name        = format(local.i18n.team_ns_ops_env_name, config.title, title(env))
              description = format(local.i18n.team_ns_ops_env_description, config.title, title(env))
              }
            }
          },
          "${id}_apps" = {
            name        = format(local.i18n.team_ns_apps_name, config.title)
            description = format(local.i18n.team_ns_apps_description, config.title)
            teams = {
              "${id}_apps_lead" = {
                name        = format(local.i18n.team_ns_apps_lead_name, config.title)
                description = format(local.i18n.team_ns_apps_lead_description, config.title)
              }
            }
          },
        }
      },

    }
  ]...)

  all_teams = merge(local.global_teams, local.namespace_teams)
}
