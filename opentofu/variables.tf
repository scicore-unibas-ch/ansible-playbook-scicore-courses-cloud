# image used for every machine.
# Query image names with "openstack image list"
data "openstack_images_image_v2" "image" {
  name = "Ubuntu Noble 24.04 (SWITCHengines)"
}

# internal network attached to every machine.
# Query network names with "openstack network list"
data "openstack_networking_network_v2" "private_net" {
  name = "private"
}

# public network attached to machines with a floating ip.
# Query network names with "openstack network list"
data "openstack_networking_network_v2" "public_net" {
  name = "public"
}

### login node
variable "login_node_vm_name" {
  default = "login-node"
}

variable "login_node_flavor_name" {
  default = "c1.large"
}

variable "login_node_volume_size" {
  default = 30
}

### slurm master
variable "slurm_master_vm_name" {
  default = "slurm-master"
}

variable "slurm_master_flavor_name" {
  default = "c1.large"
}

variable "slurm_master_volume_size" {
  default = 30
}

### slurm_worker
variable "slurm_worker_count" {
  default = 3
}

variable "slurm_worker_vm_name" {
  default = "slurm-worker"
}

variable "slurm_worker_flavor_name" {
  default = "c1.large"
}

variable "slurm_worker_volume_size" {
  default = 30
}

### nfs_server
variable "nfs_server_vm_name" {
  default = "nfs-server"
}

variable "nfs_server_flavor_name" {
  default = "c1.large"
}

variable "nfs_server_volume_size" {
  default = 30
}
