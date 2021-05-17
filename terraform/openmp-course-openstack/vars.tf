variable "openmp_course_ssh_key_name" {
  type    = string
  default = "openmp_course_cloud"
}

variable "openmp_course_nodes_count" {
  type    = number
  default = 2
}

variable "openmp_course_floating_ips_pools" {
  type    = string
  default = "public"
}

variable "openmp_course_private_network" {
  type    = string
  default = "private"
}

variable "openmp_course_image" {
  type    = string
  default = "CentOS 7 (SWITCHengines)"
}

variable "openmp_course_flavor" {
  type    = string
  default = "m1.small"
}

variable "openmp_course_open_ports" {
  type    = list
  default = [
    {
      port       = "22"
      source     = "0.0.0.0/0"
    },
    {
      port       = "3000"
      source 	 = "131.152.0.0/16"
    },
  ]
}
