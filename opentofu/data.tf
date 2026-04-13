# Image used for every VM.
# Query available images with: openstack image list
data "openstack_images_image_v2" "image" {
  name = var.image_name
}

# Internal network attached to every VM.
# Query available networks with: openstack network list
data "openstack_networking_network_v2" "private_net" {
  name = var.private_network_name
}

# Public network used for floating IPs.
# Query available networks with: openstack network list
data "openstack_networking_network_v2" "public_net" {
  name = var.public_network_name
}
