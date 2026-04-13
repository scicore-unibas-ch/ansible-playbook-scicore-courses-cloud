module "nfs_server" {
  source = "./modules/compute_node"

  name             = var.nfs_server_vm_name
  flavor_name      = var.nfs_server_flavor_name
  boot_volume_size = var.nfs_server_boot_volume_size
  image_id         = data.openstack_images_image_v2.image.id
  network_name     = data.openstack_networking_network_v2.private_net.name
  key_pair         = openstack_compute_keypair_v2.tofu_bootstrap_key.name

  # these tags define the groups this machine belongs to in the ansible inventory
  # if you add a new tag here you should also add it in inventory/openstack.yml
  tags = [
    "nfs_server",
    "course",
  ]

  security_group_names = [
    openstack_networking_secgroup_v2.opentofu_default.name,
  ]

  extra_data_volume_size = var.nfs_server_data_volume_size
}
