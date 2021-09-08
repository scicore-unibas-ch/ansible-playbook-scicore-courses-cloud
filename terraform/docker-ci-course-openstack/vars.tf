variable "docker_ci_course_ssh_key_name" {
  type    = string
  default = "docker_ci_course_cloud"
}

variable "docker_ci_course_nodes_count" {
  type    = number
  default = 2
}

variable "docker_ci_course_floating_ips_pool" {
  type    = string
  default = "public"
}

variable "docker_ci_course_private_network" {
  type    = string
  default = "private"
}

variable "docker_ci_course_image" {
  type    = string
  default = "CentOS 7 (SWITCHengines)"
}

variable "docker_ci_course_flavor" {
  type    = string
  default = "m1.small"
}

variable "docker_ci_course_open_ports" {
  type    = list
  default = [
    {
      port       = "22"
      source     = "0.0.0.0/0"
    },
    {
      port       = "80"
      source     = "0.0.0.0/0"
    },
    {
      port       = "443"
      source     = "0.0.0.0/0"
    },
    {
      port       = "8080"
      source     = "0.0.0.0/0"
    },
    {
      port       = "3000"
      source 	 = "131.152.0.0/16"
    },
  ]
}
