
resource "null_resource" "ssh_keygen" {
  provisioner "local-exec" {
    command = <<EOT
if [ ! -f "$HOME/.ssh/id_rsa_tofu" ]; then
  ssh-keygen -t rsa \
    -f "$HOME/.ssh/id_rsa_tofu" \
    -C "opentofu-bootstrap" \
    -N ""
fi
EOT
  }
}

data "local_file" "ssh_public_key" {
  filename = pathexpand("~/.ssh/id_rsa_tofu.pub")

  depends_on = [
    null_resource.ssh_keygen
  ]
}

resource "openstack_compute_keypair_v2" "tofu_bootstrap_key" {
  name       = var.ssh_key_name
  public_key = trimspace(data.local_file.ssh_public_key.content)
}
