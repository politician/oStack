# Each namespace comprises three types of repos: apps (applications), ops (operations), infra (infrastructure)

# ---------------------------------------------------------------------------------------------------------------------
# Multi-providers
# ---------------------------------------------------------------------------------------------------------------------
locals {
  ns_repos = lookup({
    github = module.ns_repos_github
  }, var.vcs_provider)
}

# ---------------------------------------------------------------------------------------------------------------------
# Computations
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Prepare namespace repos to be created
  repos_to_create = merge(flatten([for ns_id, ns_config in local.namespaces : [
    ns_config.apps.enabled ? {
      "${ns_id}_apps" = merge(ns_config.apps, { ns_id = ns_id, type = "apps" })
    } : null,

    ns_config.infra.enabled ? {
      "${ns_id}_infra" = merge(ns_config.infra, { ns_id = ns_id, type = "infra" })
    } : null,

    ns_config.ops.enabled ? {
      "${ns_id}_ops" = merge(ns_config.ops, {
        ns_id       = ns_id
        type        = "ops"
        deploy_keys = local.cluster_deploy_keys
      })
    } : null

  ]])...)

  # Prepare CODEONWERS files for managing code reviews
  repos_with_codeowners_structure = { for repo_id, config in local.repos_to_create :
    repo_id => merge(config, {
      files = merge({ for path, owners in config.reviewers :
        "CODEOWNERS" => join(" @${local.vcs_organization_name}/", concat([path], [for owner in owners : local.teams_vcs.teams[owner].slug]))...
      }, lookup(config, "files", {}))
    })
  }

  # Format each file with header/footer if any was specified in the file templates
  repos_with_files = { for repo_id, config in local.repos_with_codeowners_structure :
    repo_id => merge(config, {
      files = { for path, contents in config.files :
        (path) => try(join("\n", concat(
          compact([lookup(config.file_templates, "${trimprefix(regex("/?[^/^]+$", lower(path)), "/")}_header", "")]),
          contents,
          compact([lookup(config.file_templates, "${trimprefix(regex("/?[^/^]+$", lower(path)), "/")}_footer", "")])
        )), contents)
      }
    })
  }
}
