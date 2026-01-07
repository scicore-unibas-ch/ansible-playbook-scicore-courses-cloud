
resource "openstack_blockstorage_volume_v3" "login_node_boot_volume" {
  name     = "${var.login_node_vm_name}-boot"
  size     = var.login_node_boot_volume_size
  image_id = data.openstack_images_image_v2.image.id
}

resource "openstack_compute_instance_v2" "login_node" {
  name        = var.login_node_vm_name
  flavor_name = var.login_node_flavor_name
  key_pair    = var.ssh_key_name

  # these tags define the groups this machine belongs to in the ansible inventory
  # if you add a new tag here you should also add it in inventory/opentack.yml
  tags = [
    "login_node",
    "slurm_submit_hosts",
    "slurm", 
    "cvmfs_clients", 
    "nfs_clients",
    "course",
  ]

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.login_node_boot_volume.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    port = openstack_networking_port_v2.login_node_fip_port.id
  }
  
  depends_on = [
    openstack_blockstorage_volume_v3.login_node_boot_volume,
    openstack_networking_port_v2.login_node_fip_port,
    openstack_compute_keypair_v2.tofu_bootstrap_key
  ]
}

resource "openstack_networking_port_v2" "login_node_fip_port" {
  name               = "${var.login_node_vm_name}-port"
  network_id         = data.openstack_networking_network_v2.private_net.id
  admin_state_up     = true
}

resource "openstack_networking_floatingip_v2" "login_node_fip" {
  pool = data.openstack_networking_network_v2.public_net.name
}

resource "openstack_networking_floatingip_associate_v2" "login_node_fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.login_node_fip.address
  port_id     = openstack_networking_port_v2.login_node_fip_port.id
}
