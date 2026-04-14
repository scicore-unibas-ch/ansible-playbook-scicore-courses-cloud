variable "name" {
  description = "VM name"
  type        = string
}

variable "flavor_name" {
  description = "OpenStack flavor name"
  type        = string
}

variable "boot_volume_size" {
  description = "Boot volume size in GB"
  type        = number
}

variable "image_id" {
  description = "OpenStack image ID"
  type        = string
}

variable "network_name" {
  description = "Private network name, used when attach_floating_ip = false"
  type        = string
  default     = ""
}

variable "network_id" {
  description = "Private network ID, required when attach_floating_ip = true (port creation)"
  type        = string
  default     = ""
}

variable "key_pair" {
  description = "OpenStack keypair name"
  type        = string
}

variable "tags" {
  description = "Tags applied to the instance (map to Ansible inventory groups)"
  type        = list(string)
  default     = []
}

variable "security_group_names" {
  description = "Security group names attached at instance level (use when attach_floating_ip = false)"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Security group IDs attached at port level (use when attach_floating_ip = true)"
  type        = list(string)
  default     = []
}

variable "attach_floating_ip" {
  description = "Whether to create and attach a floating IP. When true, security groups must be passed via security_group_ids (attached at port level, not instance level — see https://search.opentofu.org/provider/terraform-provider-openstack/openstack/latest/docs/resources/compute_instance_v2#instances-and-ports)"
  type        = bool
  default     = false
}

variable "public_network_name" {
  description = "Public network name used as the floating IP pool. Required when attach_floating_ip = true"
  type        = string
  default     = ""
}

variable "extra_data_volume_size" {
  description = "Size in GB of an optional extra data volume to create and attach. Set to 0 to skip."
  type        = number
  default     = 0
}
