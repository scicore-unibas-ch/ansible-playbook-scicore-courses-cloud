terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "1.41.0"
    }
  }
}

# create default security group applied to every VM 
resource "openstack_networking_secgroup_v2" "openmp_course_default" {
  name                    = "openmp_course_default"
}

# rule for the default security group allowing any traffic inside the tenant
resource "openstack_networking_secgroup_rule_v2" "allow_any_traffic_inside_the_tenant" {
  security_group_id = openstack_networking_secgroup_v2.openmp_course_default.id
  description       = "allow any traffic inside the tenant"
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.openmp_course_default.id
}

# add security group rules for external access
resource "openstack_networking_secgroup_rule_v2" "openmp_course_open_ports" {
  security_group_id = openstack_networking_secgroup_v2.openmp_course_default.id
  count             = length(var.openmp_course_open_ports)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = var.openmp_course_open_ports[count.index].port
  port_range_max    = var.openmp_course_open_ports[count.index].port
  remote_ip_prefix  = var.openmp_course_open_ports[count.index].source
}

# boot the nodes
resource "openstack_compute_instance_v2" "openmp_course_nodes" {
  name              = format("openmp-course-%02s", count.index + 1)
  count             = var.openmp_course_nodes_count
  flavor_name       = var.openmp_course_flavor
  image_name        = var.openmp_course_image
  key_pair          = var.openmp_course_ssh_key_name
  security_groups   = [
    "openmp_course_default",
  ]
  
  network {
    name            = var.openmp_course_private_network
    access_network  = false
  }
  
}

# allocate a floating ip for each node
resource "openstack_networking_floatingip_v2" "openmp_course_floating_ips" {
  count             = var.openmp_course_nodes_count
  pool              = var.openmp_course_floating_ips_pool
}

# attach floating ips
resource "openstack_compute_floatingip_associate_v2" "floating_ip_attach_openmp_nodes" {
  count             = var.openmp_course_nodes_count
  floating_ip       = openstack_networking_floatingip_v2.openmp_course_floating_ips[count.index].address
  instance_id       = openstack_compute_instance_v2.openmp_course_nodes[count.index].id
}
