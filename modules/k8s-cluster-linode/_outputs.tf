# ---------------------------------------------------------------------------------------------------------------------
# Computations
# ---------------------------------------------------------------------------------------------------------------------
locals {
  kube_config = yamldecode(var.enable ? base64decode(linode_lke_cluster.cluster[0].kubeconfig) : "")
}

# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "kube_config" {
  description = "Kubernetes credentials file."
  value       = var.enable ? base64decode(linode_lke_cluster.cluster[0].kubeconfig) : ""
  sensitive   = true
}

output "kube_version" {
  description = "Kubernetes version."
  value       = var.enable ? linode_lke_cluster.cluster[0].k8s_version : ""
}

output "ui_url" {
  description = "Management UI."
  value       = var.enable ? "https://cloud.linode.com/kubernetes/clusters/${linode_lke_cluster.cluster[0].id}/summary" : ""
}

output "kube_host" {
  description = "Kubernetes server."
  value       = var.enable ? nonsensitive(one(local.kube_config.clusters).cluster.server) : ""
}

output "kube_ca_certificate" {
  description = "Kubernetes certificate authority certificate."
  value       = var.enable ? base64decode(one(local.kube_config.clusters).cluster.certificate-authority-data) : ""
  sensitive   = true
}

output "kube_token" {
  description = "Kubernetes authentication token."
  value       = var.enable ? one(local.kube_config.users).user.token : ""
  sensitive   = true
}
