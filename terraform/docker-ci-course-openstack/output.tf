output "docker_ci_course_floating_ips" {
  description = "Docker-CI course floating ips"
  value       = openstack_networking_floatingip_v2.docker_ci_course_floating_ips.*.address
  sensitive   = false
}

#output "docker_ci_course_nodes_details" {
#  value       = openstack_compute_instance_v2.docker_ci_course_nodes
#  sensitive   = true
#}
