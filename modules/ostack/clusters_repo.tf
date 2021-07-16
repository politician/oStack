# The clusters repo is sued to manage the clusters global configuration

# ---------------------------------------------------------------------------------------------------------------------
# Multi-providers
# ---------------------------------------------------------------------------------------------------------------------
locals {
  clusters_repo = lookup({
    github = module.clusters_repo_github
  }, var.vcs_provider)
}

# ---------------------------------------------------------------------------------------------------------------------
# Computations
# ---------------------------------------------------------------------------------------------------------------------
locals {
  clusters_base_files = {
    "_base/flux-system/gotk-components.yaml" = data.flux_install.main.content
    "_base/flux-system/gotk-sync.yaml"       = data.flux_sync.main.content
    "_base/flux-system/kustomization.yaml"   = file("${path.module}/templates/_clusters/_base/flux-system/kustomization.yaml")
    "_base/flux-system/notifications.yaml" = templatefile("${path.module}/templates/_clusters/_base/flux-system/notifications.yaml", {
      repo = "https://github.com/${local.vcs_organization_name}/_clusters"
      #repo = "https://github.com/${local.clusters_repo.full_name}"
    })
    "_base/tenants/kustomization.yaml" = templatefile("${path.module}/templates/_clusters/_base/tenants/kustomization.yaml", {
      namespaces = [for ns_id, config in local.namespaces : config.name if config.ops.enabled == true]
    })
  }

  clusters_tenants_files = merge(flatten([for ns_id, config in local.namespaces :
    {
      "_base/tenants/${config.name}/kustomization.yaml" = file("${path.module}/templates/_clusters/_base/tenants/tenant/kustomization.yaml")
      "_base/tenants/${config.name}/namespace.yaml" = templatefile("${path.module}/templates/_clusters/_base/tenants/tenant/namespace.yaml", {
        namespace = config.name
      })
      "_base/tenants/${config.name}/notifications.yaml" = templatefile("${path.module}/templates/_clusters/_base/tenants/tenant/notifications.yaml", {
        namespace = config.name
        repo      = "https://github.com/${local.vcs_organization_name}/${config.ops.repo_name}"
      })
      "_base/tenants/${config.name}/rbac.yaml" = templatefile("${path.module}/templates/_clusters/_base/tenants/tenant/rbac.yaml", {
        namespace = config.name
      })
      "_base/tenants/${config.name}/sync.yaml" = templatefile("${path.module}/templates/_clusters/_base/tenants/tenant/sync.yaml", {
        namespace = config.name
        repo_name = config.ops.repo_name
        #repo      = "https://github.com/${local.vcs_organization_name}/${config.ops.repo_name}"
        ssh_url = "ssh://git@github.com/${local.vcs_organization_name}/${config.ops.repo_name}.git"
        branch  = local.ns_repos["${ns_id}_ops"].default_branch
      })
    } if config.ops.enabled == true
  ])...)

  clusters_environments_files = merge(flatten([for env, clusters in local.environments_with_cluster_names :
    merge({
      "${env}/_base/kustomization.yaml" = file("${path.module}/templates/_clusters/env/_base/kustomization.yaml")
      "${env}/_base/tenants-patch.yaml" = templatefile("${path.module}/templates/_clusters/env/_base/tenants-patch.yaml", {
        environment = env
      })
      },
      merge([for cluster, config in clusters :
        {
          "${env}/${cluster}/kustomization.yaml" = file("${path.module}/templates/_clusters/env/cluster/kustomization.yaml")
          "${env}/${cluster}/flux-system-patch.yaml" = templatefile("${path.module}/templates/_clusters/env/cluster/flux-system-patch.yaml", {
            environment = env
            cluster     = cluster
          })
          "${env}/${cluster}/notifications-patch.yaml" = templatefile("${path.module}/templates/_clusters/env/cluster/notifications-patch.yaml", {
            cluster = cluster
          })
          "_infra/${cluster}.tf" = templatefile("${path.module}/templates/_clusters/_infra/cluster.tf.tpl", {
            cluster = cluster
          })
        }
    ]...))
  ])...)

  clusters_files = merge(local.clusters_base_files, local.clusters_tenants_files, local.clusters_environments_files)

  clusters_sensitive_inputs = { for cluster in keys(local.clusters_to_create) :
    "${cluster}_ssh_key" => tls_private_key.cluster_keys[cluster].public_key_openssh
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------------------------------------------------
# Generate manifests used by Flux
data "flux_install" "main" {
  target_path    = "_base"
  network_policy = false
}

data "flux_sync" "main" {
  target_path = "_base/flux-system"
  url         = "ssh://git@github.com/${local.vcs_organization_name}/_clusters.git"
  #branch      = local.clusters_repo.default_branch
  branch = "main"
}
