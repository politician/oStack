<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version |
| ------------------------------------------------------------------------ | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | ~> 1.0  |
| <a name="requirement_flux"></a> [flux](#requirement_flux)                | 0.1.10  |
| <a name="requirement_github"></a> [github](#requirement_github)          | ~> 4.0  |
| <a name="requirement_tls"></a> [tls](#requirement_tls)                   | 3.1.0   |

## Providers

| Name                                                      | Version |
| --------------------------------------------------------- | ------- |
| <a name="provider_flux"></a> [flux](#provider_flux)       | 0.1.10  |
| <a name="provider_github"></a> [github](#provider_github) | 4.11.0  |
| <a name="provider_tls"></a> [tls](#provider_tls)          | 3.1.0   |

## Modules

| Name | Source | Version |
| --- | --- | --- |
| <a name="module_clusters_backend_tfe"></a> [clusters_backend_tfe](#module_clusters_backend_tfe) | ../backend-tfe | n/a |
| <a name="module_clusters_k8s_digitalocean"></a> [clusters_k8s_digitalocean](#module_clusters_k8s_digitalocean) | ../k8s-cluster-digitalocean | n/a |
| <a name="module_clusters_k8s_linode"></a> [clusters_k8s_linode](#module_clusters_k8s_linode) | ../k8s-cluster-linode | n/a |
| <a name="module_clusters_repo_github"></a> [clusters_repo_github](#module_clusters_repo_github) | ../repo-github | n/a |
| <a name="module_configuration_repo_github"></a> [configuration_repo_github](#module_configuration_repo_github) | ../repo-github | n/a |
| <a name="module_configuration_repo_gitlab"></a> [configuration_repo_gitlab](#module_configuration_repo_gitlab) | ../repo-github | n/a |
| <a name="module_ns_backends_tfe"></a> [ns_backends_tfe](#module_ns_backends_tfe) | ../backend-tfe | n/a |
| <a name="module_ns_repos_github"></a> [ns_repos_github](#module_ns_repos_github) | ../repo-github | n/a |
| <a name="module_ns_repos_gitlab"></a> [ns_repos_gitlab](#module_ns_repos_gitlab) | ../repo-github | n/a |
| <a name="module_teams_vcs_github"></a> [teams_vcs_github](#module_teams_vcs_github) | ../teams-github | n/a |
| <a name="module_teams_vcs_gitlab"></a> [teams_vcs_gitlab](#module_teams_vcs_gitlab) | ../teams-github | n/a |

## Resources

| Name | Type |
| --- | --- |
| [tls_private_key.cluster_keys](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) | resource |
| [tls_private_key.ns_keys](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) | resource |
| [flux_install.main](https://registry.terraform.io/providers/fluxcd/flux/0.1.10/docs/data-sources/install) | data source |
| [flux_sync.main](https://registry.terraform.io/providers/fluxcd/flux/0.1.10/docs/data-sources/sync) | data source |
| [github_user.current](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/user) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | :-: |
| <a name="input_organization_title"></a> [organization_title](#input_organization_title) | Organization title (eg. My Super Startup). | `string` | n/a | yes |
| <a name="input_tfe_oauth_token_id"></a> [tfe_oauth_token_id](#input_tfe_oauth_token_id) | VCS OAuth connection ID. https://www.terraform.io/docs/cloud/vcs/index.html | `string` | n/a | yes |
| <a name="input_vcs_token_write"></a> [vcs_token_write](#input_vcs_token_write) | VCS token. | `string` | n/a | yes |
| <a name="input_backend_organization_name"></a> [backend_organization_name](#input_backend_organization_name) | Backend organization name. | `string` | `null` | no |
| <a name="input_backend_provider"></a> [backend_provider](#input_backend_provider) | Backend provider. | `string` | `"tfe"` | no |
| <a name="input_environments"></a> [environments](#input_environments) | Environment names and their optional cluster configuration. <br>Note that all namespaces are assigned to all clusters unless the `namespaces` parameter is set. | <pre>map(list(object({<br> region = optional(string)<br> nodes = optional(map(number))<br> kube_version = optional(string)<br> sensitive_kube_config = optional(string)<br> })))</pre> | <pre>{<br> "staging": []<br>}</pre> | no |
| <a name="input_lang"></a> [lang](#input_lang) | Translation file to use. This can be one of the bundled translations of oStack or a custom translation object. <br>This can be used to overwrite how things are called through your stack. | `any` | `"en"` | no |
| <a name="input_namespaces"></a> [namespaces](#input_namespaces) | Namespaces and their optional configuration. <br>A namespace can be a project or a group of projects (if using a monorepo structure).<br>By default a namespace bearing the same name as your organization will be created. <br>If you want to later rename your namespaces, do not change the key name or Terraform will destroy it and create a new one from scratch. As such it is recommended to use generic key names such as ns1, ns2. | <pre>map(object({<br> title = string<br> name = optional(string)<br> description = optional(string)<br> environments = optional(list(string))<br> infra = optional(object({<br> branch_default_name = optional(string)<br> branch_delete_on_merge = optional(bool)<br> branch_protection = optional(bool)<br> branch_review_count = optional(number)<br> branch_status_checks = optional(list(string))<br> continuous_delivery = optional(bool)<br> description = optional(string)<br> enabled = optional(bool)<br> repo_allow_merge_commit = optional(bool)<br> repo_allow_rebase_merge = optional(bool)<br> repo_allow_squash_merge = optional(bool)<br> repo_enable_issues = optional(bool)<br> repo_enable_projects = optional(bool)<br> repo_enable_wikis = optional(bool)<br> repo_issue_labels = optional(map(string))<br> repo_name = optional(string)<br> repo_private = optional(bool)<br> backend_secrets = optional(map(string))<br> repo_secrets = optional(map(string))<br> repo_template = optional(string)<br> tags = optional(set(string))<br> file_templates = optional(object({<br> codeowners_header = optional(string)<br> codeowners_footer = optional(string)<br> }))<br> }))<br> ops = optional(object({<br> branch_default_name = optional(string)<br> branch_delete_on_merge = optional(bool)<br> branch_protection = optional(bool)<br> branch_review_count = optional(number)<br> branch_status_checks = optional(list(string))<br> continuous_delivery = optional(bool)<br> description = optional(string)<br> enabled = optional(bool)<br> repo_allow_merge_commit = optional(bool)<br> repo_allow_rebase_merge = optional(bool)<br> repo_allow_squash_merge = optional(bool)<br> repo_enable_issues = optional(bool)<br> repo_enable_projects = optional(bool)<br> repo_enable_wikis = optional(bool)<br> repo_issue_labels = optional(map(string))<br> repo_name = optional(string)<br> repo_private = optional(bool)<br> repo_secrets = optional(map(string))<br> repo_template = optional(string)<br> tags = optional(set(string))<br> file_templates = optional(object({<br> codeowners_header = optional(string)<br> codeowners_footer = optional(string)<br> }))<br> }))<br> apps = optional(object({<br> branch_default_name = optional(string)<br> branch_delete_on_merge = optional(bool)<br> branch_protection = optional(bool)<br> branch_review_count = optional(number)<br> branch_status_checks = optional(list(string))<br> continuous_delivery = optional(bool)<br> description = optional(string)<br> enabled = optional(bool)<br> repo_allow_merge_commit = optional(bool)<br> repo_allow_rebase_merge = optional(bool)<br> repo_allow_squash_merge = optional(bool)<br> repo_enable_issues = optional(bool)<br> repo_enable_projects = optional(bool)<br> repo_enable_wikis = optional(bool)<br> repo_issue_labels = optional(map(string))<br> repo_name = optional(string)<br> repo_private = optional(bool)<br> repo_secrets = optional(map(string))<br> repo_template = optional(string)<br> tags = optional(set(string))<br> file_templates = optional(object({<br> codeowners_header = optional(string)<br> codeowners_footer = optional(string)<br> }))<br> }))<br> }))</pre> | <pre>{<br> "ns1": {<br> "title": null<br> }<br>}</pre> | no |
| <a name="input_organization_name"></a> [organization_name](#input_organization_name) | Organization name (eg. my-super-startup). <br>Use only letters, numbers and dashes to maximize compatibility across every system. | `string` | `null` | no |
| <a name="input_sensitive_inputs"></a> [sensitive_inputs](#input_sensitive_inputs) | Pass sensitive inputs here | `map(string)` | `{}` | no |
| <a name="input_vcs_automation_user_name"></a> [vcs_automation_user_name](#input_vcs_automation_user_name) | VCS username associated with the token used for automation.<br>Defaults to current user. | `string` | `""` | no |
| <a name="input_vcs_configuration_base"></a> [vcs_configuration_base](#input_vcs_configuration_base) | Base configuration for the VCS. | <pre>object({<br> branch_default_name = optional(string)<br> branch_delete_on_merge = optional(bool)<br> branch_protection = optional(bool)<br> branch_review_count = optional(number)<br> branch_status_checks = optional(list(string))<br> repo_allow_merge_commit = optional(bool)<br> repo_allow_rebase_merge = optional(bool)<br> repo_allow_squash_merge = optional(bool)<br> repo_enable_issues = optional(bool)<br> repo_enable_projects = optional(bool)<br> repo_enable_wikis = optional(bool)<br> repo_issue_labels = optional(map(string))<br> repo_private = optional(bool)<br> repo_secrets = optional(map(string))<br> repo_template = optional(string)<br> tags = optional(set(string))<br> file_templates = optional(object({<br> codeowners_header = optional(string)<br> codeowners_footer = optional(string)<br> }))<br> })</pre> | `{}` | no |
| <a name="input_vcs_organization_name"></a> [vcs_organization_name](#input_vcs_organization_name) | VCS Organization name. | `string` | `null` | no |
| <a name="input_vcs_provider"></a> [vcs_provider](#input_vcs_provider) | VCS provider. | `string` | `"github"` | no |

## Outputs

| Name | Description |
| --- | --- |
| <a name="output_clusters"></a> [clusters](#output_clusters) | Kubeconfig files for each cluster. |
| <a name="output_environments"></a> [environments](#output_environments) | Full configuration for all environments. |
| <a name="output_namespaces"></a> [namespaces](#output_namespaces) | Full configuration for all namespaces. |
| <a name="output_teams"></a> [teams](#output_teams) | VCS teams created. |

<!-- END_TF_DOCS -->
