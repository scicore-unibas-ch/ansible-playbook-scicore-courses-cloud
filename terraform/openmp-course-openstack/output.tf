output "openmp_course_floating_ips" {
  description = "OpenMP course floating ips"
  value       = openstack_networking_floatingip_v2.openmp_course_floating_ips.*.address
  sensitive   = false
}

#output "openmp_course_nodes_details" {
#  value       = openstack_compute_instance_v2.openmp_course_nodes
#  sensitive   = true
#}
