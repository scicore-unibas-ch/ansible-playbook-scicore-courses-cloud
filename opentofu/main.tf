terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "3.3.0"
    }
    null = {
      source  = "hashicorp/null"
    }
    # tls = {
    #   source  = "hashicorp/tls"
    # }
    local = {
      source  = "hashicorp/local"
    }
  }
}

resource "null_resource" "ssh_keygen" {
  provisioner "local-exec" {
    command = <<EOT
if [ ! -f "$HOME/.ssh/id_rsa_tofu" ]; then
  ssh-keygen -t rsa \
    -f "$HOME/.ssh/id_rsa_tofu" \
    -C "openstack-tofu-bootstrap" \
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
  # public_key = data.local_file.ssh_public_key.content
  public_key = trimspace(data.local_file.ssh_public_key.content)
  #public_key = replace(trimspace(data.local_file.ssh_public_key.content), "/\r/", "")
  #public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGIaAJnBofaTYgP317esrMNEnY+hs1UQxi05/N06HiHH openstack-tofu-bootstrap"

}


# resource "tls_private_key" "user_ssh_key" {
#   algorithm = "ED25519"

#   lifecycle {
#     prevent_destroy = true
#   }
# }

# resource "openstack_compute_keypair_v2" "os_user_keypair" {
#   name       = var.ssh_key_name

#   # lifecycle {
#   #   prevent_destroy = true
#   # }
# }

# resource "local_file" "user_private_ssh_key" {
#   filename        = pathexpand(var.ssh_key_path)
#   content         = openstack_compute_keypair_v2.os_user_keypair.private_key
#   file_permission = "0600"

#   # lifecycle {
#   #   prevent_destroy = true
#   # }
# }

# resource "local_file" "user_public_ssh_key" {
#   filename        = "${pathexpand(var.ssh_key_path)}.pub"
#   content         = openstack_compute_keypair_v2.os_user_keypair.public_key
#   file_permission = "0644"

#   # lifecycle {
#   #   prevent_destroy = true
#   # }
# }

