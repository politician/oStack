# ---------------------------------------------------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------------------------------------------------
module "clusters_k8s_linode" {
  source = "../k8s-cluster-linode"

  enable   = local.cloud_provider == "linode"
  for_each = local.clusters_to_create

  kube_version = each.value.kube_version
  name         = each.key
  nodes        = each.value.nodes
  region       = each.value.region
  tags         = each.value.tags
}
