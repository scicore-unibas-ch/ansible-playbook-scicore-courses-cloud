module "slurm_master" {
  source = "./modules/compute_node"

  name             = var.slurm_master_vm_name
  flavor_name      = var.slurm_master_flavor_name
  boot_volume_size = var.slurm_master_boot_volume_size
  image_id         = data.openstack_images_image_v2.image.id
  network_name     = data.openstack_networking_network_v2.private_net.name
  key_pair         = openstack_compute_keypair_v2.tofu_bootstrap_key.name

  # these tags define the groups this machine belongs to in the ansible inventory
  tags = [
    "slurm_master",
    "slurm",
    "course",
  ]

  security_group_names = [
    openstack_networking_secgroup_v2.opentofu_default.name,
  ]
}
