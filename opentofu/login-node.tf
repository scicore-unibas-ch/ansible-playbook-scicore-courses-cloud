module "login_node" {
  source = "./modules/compute_node"

  name             = var.login_node_vm_name
  flavor_name      = var.login_node_flavor_name
  boot_volume_size = var.login_node_boot_volume_size
  image_id         = data.openstack_images_image_v2.image.id
  key_pair         = openstack_compute_keypair_v2.tofu_bootstrap_key.name

  # these tags define the groups this machine belongs to in the ansible inventory
  tags = [
    "login_node",
    "slurm_submit_hosts",
    "slurm",
    "cvmfs_clients",
    "nfs_clients",
    "course",
  ]

  # floating IP requires security groups attached at port level (not instance level)
  attach_floating_ip  = true
  network_id          = data.openstack_networking_network_v2.private_net.id
  public_network_name = data.openstack_networking_network_v2.public_net.name
  security_group_ids = [
    openstack_networking_secgroup_v2.opentofu_default.id,
    openstack_networking_secgroup_v2.opentofu_login_node.id,
  ]
}
