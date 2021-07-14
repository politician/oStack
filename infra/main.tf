// Generate "deploy key" to be used by Copybara
resource "tls_private_key" "copybara_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

// Add the key to user profile
resource "github_user_ssh_key" "copybara_ssh_key" {
  title = "Generated from oStack monorepo"
  key   = tls_private_key.copybara_ssh_key.public_key_openssh
}
