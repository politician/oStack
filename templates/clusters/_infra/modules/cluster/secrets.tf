# SSH
locals {
  known_hosts = "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="
}

# Generate Kubernetes secrets with the Git credentials
resource "kubernetes_secret" "deploy_keys" {
  for_each   = var.deploy_keys
  depends_on = [kubectl_manifest.install, kubectl_manifest.sync]

  metadata {
    name      = each.value.name
    namespace = each.value.namespace
  }

  data = {
    identity       = var.sensitive_inputs["${each.key}_private_key"]
    "identity.pub" = base64decode(each.value.public_key)
    known_hosts    = local.known_hosts
  }
}

resource "kubernetes_secret" "vcs_token" {
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = "vcs-token"
    namespace = "flux-system"
  }

  data = {
    token = var.vcs_token
  }
}
