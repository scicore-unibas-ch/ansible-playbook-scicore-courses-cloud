resource "openstack_blockstorage_volume_v3" "slurm_worker_boot_volume" {
  count    = var.slurm_worker_count
  name     = "${var.slurm_worker_vm_name}-${count.index}-boot"
  size     = var.slurm_worker_volume_size
  image_id = data.openstack_images_image_v2.image.id
}

resource "openstack_compute_instance_v2" "slurm_worker" {
  count       = var.slurm_worker_count
  name        = "${var.slurm_worker_vm_name}-${count.index}"
  flavor_name = var.slurm_worker_flavor_name
  key_pair    = "root-aivo"

  # these tags define the groups this machine belongs to in the ansible inventory
  # if you add a new tag here you should also add it in inventory/opentack.yml
  tags = [
    "slurm_worker",
    "slurm", 
    "cvmfs_clients", 
    "nfs_clients",
    "course",
  ]

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.slurm_worker_boot_volume[count.index].id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }
  
  network {
    name = data.openstack_networking_network_v2.private_net.name
  }

  depends_on = [openstack_blockstorage_volume_v3.slurm_worker_boot_volume]
}
