variable "slurm_image" {
  type    = string
  default = "CentOS 7 (SWITCHengines)"
}

variable "slurm_login_flavor" {
  type    = string
  default = "m1.small"
}

variable "slurm_login_open_ports" {
  type    = list
  default = [
    {
      port       = "22"
      source     = "0.0.0.0/0"
    },
    {
      port       = "80"
      source 	 = "0.0.0.0/0"
    },
    {
      port       = "443"
      source 	 = "0.0.0.0/0"
    },
    {
      port       = "3000"
      source 	 = "131.152.0.0/16"
    },
  ]
}

variable "slurm_nfs_server_shared_disk_size" {
  type    = number
  default = 50
}

variable "slurm_compute_flavor" {
  type    = string
  default = "m1.small"
}

variable "slurm_ssh_key_name" {
  type    = string
  default = "slurm_cluster"
}

variable "slurm_compute_nodes_count" {
  type    = number
  default = 2
}

variable "slurm_floating_ips_pools" {
  type    = string
  default = "public"
}

variable "slurm_private_network" {
  type    = string
  default = "private"
}
