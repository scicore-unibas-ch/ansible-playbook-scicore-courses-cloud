output "instance_id" {
  description = "ID of the compute instance"
  value       = openstack_compute_instance_v2.instance.id
}

output "floating_ip" {
  description = "Floating IP address (empty string if attach_floating_ip = false)"
  value       = var.attach_floating_ip ? openstack_networking_floatingip_v2.fip[0].address : ""
}
