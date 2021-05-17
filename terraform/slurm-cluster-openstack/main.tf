terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "1.41.0"
    }
  }
}

# create default security group applied to every VM 
resource "openstack_networking_secgroup_v2" "slurm_default" {
  name                    = "slurm_default"
}

# rule for the default security group allowing any traffic inside the tenant
resource "openstack_networking_secgroup_rule_v2" "allow_any_traffic_inside_the_tenant" {
  security_group_id = openstack_networking_secgroup_v2.slurm_default.id
  description       = "allow any traffic inside the tenant"
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.slurm_default.id
}

# create security group for login node
resource "openstack_networking_secgroup_v2" "slurm_login" {
  name                    = "slurm_login"
}

# add security group rules for login node
resource "openstack_networking_secgroup_rule_v2" "slurm_login_open_ports" {
  security_group_id = openstack_networking_secgroup_v2.slurm_login.id
  count             = length(var.slurm_login_open_ports)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = var.slurm_login_open_ports[count.index].port
  port_range_max    = var.slurm_login_open_ports[count.index].port
  remote_ip_prefix  = var.slurm_login_open_ports[count.index].source
}

# boot slurm-login
resource "openstack_compute_instance_v2" "slurm_login" {
  name              = "slurm-login"
  flavor_name       = var.slurm_login_flavor
  image_name        = var.slurm_image
  key_pair          = var.slurm_ssh_key_name
  security_groups   = [
    "slurm_default",
    "slurm_login",
  ]

  network {
    name            = var.slurm_private_network
    access_network  = false
  }

}

# create disk for NFS share from login node
resource "openstack_blockstorage_volume_v3" "slurm_login_nfs_data_disk" {
  name  = "slurm_login_nfs_data"
  size  = var.slurm_nfs_server_shared_disk_size
}

# attach the NFS data disk to the login node
resource "openstack_compute_volume_attach_v2" "attach_nfs_data_disk_to_slurm_login" {
  instance_id = openstack_compute_instance_v2.slurm_login.id
  volume_id   = openstack_blockstorage_volume_v3.slurm_login_nfs_data_disk.id
}

# allocate a floating ip for the login node
resource "openstack_networking_floatingip_v2" "floating_ip_slurm_login" {
  pool              = var.slurm_floating_ips_pools
}

# attach floating ip to the login node
resource "openstack_compute_floatingip_associate_v2" "floating_ip_attach_slurm_login" {
  floating_ip       = openstack_networking_floatingip_v2.floating_ip_slurm_login.address
  instance_id       = openstack_compute_instance_v2.slurm_login.id
}

# boot all the slurm compute nodes
resource "openstack_compute_instance_v2" "slurm_compute_nodes" {
  name              = format("slurm-compute-%02s", count.index + 1)
  count             = var.slurm_compute_nodes_count
  flavor_name       = var.slurm_compute_flavor
  image_name        = var.slurm_image
  key_pair          = var.slurm_ssh_key_name
  security_groups   = [
    "slurm_default",
  ]
  
  network {
    name            = var.slurm_private_network
    access_network  = false
  }
  
}
