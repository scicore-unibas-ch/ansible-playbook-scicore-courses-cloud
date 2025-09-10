resource "openstack_blockstorage_volume_v3" "nfs_server_boot_volume" {
  name     = "${var.nfs_server_vm_name}-boot"
  size     = var.nfs_server_boot_volume_size
  image_id = data.openstack_images_image_v2.image.id
}

resource "openstack_compute_instance_v2" "nfs_server" {
  name        = var.nfs_server_vm_name
  flavor_name = var.nfs_server_flavor_name
  key_pair    = "root-aivo"

  # these tags define the groups this machine belongs to in the ansible inventory
  # if you add a new tag here you should also add it in inventory/opentack.yml
  tags = [
    "nfs_server",
    "course", 
  ]

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.nfs_server_boot_volume.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }
  
  network {
    name = data.openstack_networking_network_v2.private_net.name
  }

  depends_on = [openstack_blockstorage_volume_v3.nfs_server_boot_volume]
}

# create an extra volume for NFS share
resource "openstack_blockstorage_volume_v3" "nfs_server_data_vol" {
  name = "nfs-server-data-volume"
  size = var.nfs_server_data_volume_size
}

resource "openstack_compute_volume_attach_v2" "nfs_server_data_vol_attach" {
  instance_id = openstack_compute_instance_v2.nfs_server.id
  volume_id   = openstack_blockstorage_volume_v3.nfs_server_data_vol.id
}

