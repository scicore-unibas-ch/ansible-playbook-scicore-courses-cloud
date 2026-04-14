### OpenStack infrastructure

variable "image_name" {
  description = "Name of the OpenStack image used for every VM. Query with: openstack image list"
  type        = string
}

variable "private_network_name" {
  description = "Name of the internal network attached to every VM. Query with: openstack network list"
  type        = string
  default     = "UNIBAS"
}

variable "public_network_name" {
  description = "Name of the public network used for floating IPs. Query with: openstack network list"
  type        = string
  default     = "public"
}

variable "ssh_key_name" {
  description = "Name of the SSH keypair in OpenStack"
  type        = string
  default     = "opentofu_key"
}

### login node

variable "login_node_vm_name" {
  description = "Name of the login node VM"
  type        = string
  default     = "login-node"
}

variable "login_node_flavor_name" {
  description = "OpenStack flavor for the login node. Query with: openstack flavor list"
  type        = string
}

variable "login_node_boot_volume_size" {
  description = "Boot volume size in GB for the login node"
  type        = number
}

### slurm master

variable "slurm_master_vm_name" {
  description = "Name of the SLURM master VM"
  type        = string
  default     = "slurm-master"
}

variable "slurm_master_flavor_name" {
  description = "OpenStack flavor for the SLURM master. Query with: openstack flavor list"
  type        = string
}

variable "slurm_master_boot_volume_size" {
  description = "Boot volume size in GB for the SLURM master"
  type        = number
}

### slurm workers

variable "slurm_worker_count" {
  description = "Number of SLURM worker nodes to provision"
  type        = number
}

variable "slurm_worker_vm_name" {
  description = "Base name for SLURM worker VMs (suffixed with index)"
  type        = string
  default     = "slurm-worker"
}

variable "slurm_worker_flavor_name" {
  description = "OpenStack flavor for SLURM workers. Query with: openstack flavor list"
  type        = string
}

variable "slurm_worker_boot_volume_size" {
  description = "Boot volume size in GB for each SLURM worker"
  type        = number
}

### nfs server

variable "nfs_server_vm_name" {
  description = "Name of the NFS server VM"
  type        = string
  default     = "nfs-server"
}

variable "nfs_server_flavor_name" {
  description = "OpenStack flavor for the NFS server. Query with: openstack flavor list"
  type        = string
}

variable "nfs_server_boot_volume_size" {
  description = "Boot volume size in GB for the NFS server"
  type        = number
}

variable "nfs_server_data_volume_size" {
  description = "Data volume size in GB for NFS shared storage"
  type        = number
}
