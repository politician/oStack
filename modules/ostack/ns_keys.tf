# ---------------------------------------------------------------------------------------------------------------------
# Computations
# ---------------------------------------------------------------------------------------------------------------------
locals {
  ns_ops_repos = { for id, config in local.repos_to_create :
    id => config if config.type == "ops"
  }

  ns_keys_to_create = [for pair in setproduct(keys(local.ns_ops_repos), keys(local.clusters_to_create)) :
    "${pair[0]}_${pair[1]}"
  ]

  ns_repos_sensitive_inputs = { for id, config in local.repos_to_create :
    id => merge({ for k, v in var.sensitive_inputs :
      k => v if contains(keys(config.repo_secrets), k)
      }, config.type != "ops" ? {} : { for cluster in keys(local.clusters_to_create) :
      "${cluster}_ssh_key" => tls_private_key.ns_keys["${id}_${cluster}"].public_key_openssh
      }
    )
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------------------------------------------------
# Generate deploy keys to be used by Flux
resource "tls_private_key" "ns_keys" {
  for_each = toset(local.ns_keys_to_create)

  algorithm = "RSA"
  rsa_bits  = 4096
}

