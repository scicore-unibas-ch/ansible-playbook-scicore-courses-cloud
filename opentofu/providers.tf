terraform {

  required_providers {

    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "3.3.0"
    }

    null = {
      source  = "hashicorp/null"
    }

    local = {
      source  = "hashicorp/local"
    }

  }
}
