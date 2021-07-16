provider "kubernetes" {
  alias                  = "${cluster}"
  host                   = var.clusters["${cluster}"].kube_host
  cluster_ca_certificate = base64decode(var.clusters["${cluster}"].kube_ca_certificate)
  token                  = var.sensitive_inputs_per_cluster["${cluster}"].kube_token
}

provider "kubectl" {
  alias                  = "${cluster}"
  host                   = var.clusters["${cluster}"].kube_host
  cluster_ca_certificate = base64decode(var.clusters["${cluster}"].kube_ca_certificate)
  token                  = var.sensitive_inputs_per_cluster["${cluster}"].kube_token
  load_config_file       = false
}

module "${cluster}" {
  source = "./modules/cluster"
  providers = {
    kubernetes = kubernetes.${cluster}
    kubectl    = kubectl.${cluster}
  }

  cluster_path     = var.clusters["${cluster}"].cluster_path
  deploy_keys      = var.clusters["${cluster}"].deploy_keys
  sensitive_inputs = var.sensitive_inputs_per_cluster["${cluster}"]
  vcs_token        = var.vcs_token
}
