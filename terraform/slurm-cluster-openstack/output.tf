output "slurm_login_floating_ip" {
  description = "just testing"
  value       = openstack_networking_floatingip_v2.floating_ip_slurm_login.address
  sensitive   = false
}

output "slurm_login_internal_ip" {
  description = "just testing"
  value       = openstack_compute_instance_v2.slurm_login.network[0].fixed_ip_v4
  sensitive   = false
}

output "slurm_login_node_details" {
  description = "just testing"
  value       = openstack_compute_instance_v2.slurm_login
  sensitive   = true
}

output "slurm_compute_nodes_details" {
  description = "just testing"
  value       = openstack_compute_instance_v2.slurm_compute_nodes
  sensitive   = true
}
