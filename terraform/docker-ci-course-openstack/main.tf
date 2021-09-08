terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "1.41.0"
    }
  }
}

# create default security group applied to every VM 
resource "openstack_networking_secgroup_v2" "docker_ci_course_default" {
  name              = "docker_ci_course_default"
}

# add security group rules for external access
resource "openstack_networking_secgroup_rule_v2" "docker_ci_course_open_ports" {
  security_group_id = openstack_networking_secgroup_v2.docker_ci_course_default.id
  count             = length(var.docker_ci_course_open_ports)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = var.docker_ci_course_open_ports[count.index].port
  port_range_max    = var.docker_ci_course_open_ports[count.index].port
  remote_ip_prefix  = var.docker_ci_course_open_ports[count.index].source
}

# boot the nodes
resource "openstack_compute_instance_v2" "docker_ci_course_nodes" {
  name              = format("docker-ci-course-%02s", count.index + 1)
  count             = var.docker_ci_course_nodes_count
  flavor_name       = var.docker_ci_course_flavor
  image_name        = var.docker_ci_course_image
  key_pair          = var.docker_ci_course_ssh_key_name
  security_groups   = [
    "docker_ci_course_default",
  ]
  
  network {
    name            = var.docker_ci_course_private_network
    access_network  = false
  }
  
}

# allocate a floating ip for each node
resource "openstack_networking_floatingip_v2" "docker_ci_course_floating_ips" {
  count             = var.docker_ci_course_nodes_count
  pool              = var.docker_ci_course_floating_ips_pool
}

# attach floating ips
resource "openstack_compute_floatingip_associate_v2" "floating_ip_attach_docker_ci_nodes" {
  count             = var.docker_ci_course_nodes_count
  floating_ip       = openstack_networking_floatingip_v2.docker_ci_course_floating_ips[count.index].address
  instance_id       = openstack_compute_instance_v2.docker_ci_course_nodes[count.index].id
}
