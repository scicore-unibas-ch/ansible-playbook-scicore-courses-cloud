resource "openstack_networking_secgroup_v2" "opentofu_default" {
  name                    = "opentofu_default"
  delete_default_rules    = true
}

resource "openstack_networking_secgroup_rule_v2" "allow_any_outgoing_traffic_ipv4" {
  security_group_id = openstack_networking_secgroup_v2.opentofu_default.id
  description       = "allow any outgoing traffic"
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "allow_any_from_lan" {
  security_group_id = openstack_networking_secgroup_v2.opentofu_default.id
  description       = "allow any from LAN"
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.opentofu_default.id
}

resource "openstack_networking_secgroup_v2" "opentofu_login_node" {
  name                    = "opentofu_login_node"
  delete_default_rules    = true
}

resource "openstack_networking_secgroup_rule_v2" "allow_ssh_from_internet" {
  security_group_id = openstack_networking_secgroup_v2.opentofu_login_node.id
  description       = "allow ssh from internet"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "allow_rstudio_from_internet" {
  security_group_id = openstack_networking_secgroup_v2.opentofu_login_node.id
  description       = "allow rstudio from internet"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8787
  port_range_max    = 8787
  remote_ip_prefix  = "0.0.0.0/0"
}
