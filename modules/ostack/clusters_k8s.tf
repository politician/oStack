locals {
  cloud_provider = "linode"
}


# ---------------------------------------------------------------------------------------------------------------------
# Multi-providers
# ---------------------------------------------------------------------------------------------------------------------
locals {
  clusters_k8s = lookup({
    linode = module.clusters_k8s_linode
  }, local.cloud_provider)
}

# ---------------------------------------------------------------------------------------------------------------------
# Computations
# ---------------------------------------------------------------------------------------------------------------------
locals {
  environments_with_cluster_names = { for env, configs in local.environments :
    env => { for config in configs : join("-", [local.organization_name, env, index(configs, config) + 1]) => config }
  }

  clusters_to_create = merge(flatten([for env, configs in local.environments_with_cluster_names : {
    for key, config in configs : key => merge(config, {
      environment = env
      tags = flatten(concat(
        [local.organization_name, env],
        [for ns in local.namespaces : ns.name if contains(ns.environments, env)]
      ))
    }) if lookup(config, "sensitive_kube_config", null) == null
  }])...)
}
