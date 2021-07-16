# ---------------------------------------------------------------------------------------------------------------------
# Computations
# ---------------------------------------------------------------------------------------------------------------------
locals {
  cluster_deploy_keys = { for cluster in keys(local.clusters_to_create) :
    (cluster) => {
      title    = cluster
      ssh_key  = null
      readonly = true
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------------------------------------------------
# Generate "deploy key" to be used by Flux
resource "tls_private_key" "cluster_keys" {
  for_each = toset(keys(local.clusters_to_create))

  algorithm = "RSA"
  rsa_bits  = 4096
}
