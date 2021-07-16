# ---------------------------------------------------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------------------------------------------------
resource "linode_lke_cluster" "cluster" {
  count = var.enable ? 1 : 0

  label       = var.name
  k8s_version = var.kube_version
  region      = var.region
  tags        = var.tags

  dynamic "pool" {
    for_each = var.nodes
    content {
      type  = pool.key
      count = pool.value
    }
  }
}
