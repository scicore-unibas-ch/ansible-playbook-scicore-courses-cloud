#!/bin/bash

ansible-playbook -e @config/slurm_cluster_switch_cloud.yml ansible/slurm_cluster_boot_openstack.yml
ansible-playbook -i ansible/inventory/hosts -e @config/slurm_cluster_switch_cloud.yml ansible/slurm_cluster_configure_nfs_server.yml
ansible-playbook -i ansible/inventory/hosts -e @config/slurm_cluster_switch_cloud.yml ansible/slurm_cluster_configure_slurm_daemons.yml
ansible-playbook -i ansible/inventory/hosts -e @config/slurm_cluster_switch_cloud.yml ansible/slurm_cluster_configure_user_accounts.yml
