# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "namespaces" {
  description = "Full configuration for all namespaces."
  value = { for ns, config in local.namespaces :
    ns => merge(config, {
      apps = merge(config.apps, {
        repo_url       = try(local.ns_repos[config.apps.repo_name].html_url, null)
        repo_full_name = try(local.ns_repos[config.apps.repo_name].full_name, null)
      })
      ops = merge(config.ops, {
        repo_url       = try(local.ns_repos[config.ops.repo_name].html_url, null)
        repo_full_name = try(local.ns_repos[config.ops.repo_name].full_name, null)
      })
      infra = merge(config.infra, {
        repo_url       = try(local.ns_repos[config.infra.repo_name].html_url, null)
        repo_full_name = try(local.ns_repos[config.infra.repo_name].full_name, null)
      })
    })
  }
}

output "teams" {
  description = "VCS teams created."
  value       = local.teams_vcs.teams
}

output "environments" {
  description = "Full configuration for all environments."
  value       = local.environments_with_cluster_names
}

output "clusters" {
  description = "Kubeconfig files for each cluster."
  sensitive   = true
  value = { for cluster, config in local.environments_with_cluster_names :
    cluster => lookup(config, "sensitive_kube_config", null) != null ? lookup(var.sensitive_inputs, config.sensitive_kube_config, null) : try(local.clusters_k8s[cluster].kube_config, null)
  }
}
