#!/bin/bash

#ANSIBLE_FORKS=10

CONFIG_FILE="config/slurm_cluster_switch_cloud.yml"
ANSIBLE_STATIC_INVENTORY="ansible/inventory/slurm_cluster"

ansible-playbook -e @${CONFIG_FILE} ansible/slurm-cluster-01-boot-openstack.yml
ansible-playbook -e @${CONFIG_FILE} -i ${ANSIBLE_STATIC_INVENTORY} ansible/slurm-cluster-02-common.yml
ansible-playbook -e @${CONFIG_FILE} -i ${ANSIBLE_STATIC_INVENTORY} ansible/slurm-cluster-03-configure-nfs.yml
ansible-playbook -e @${CONFIG_FILE} -i ${ANSIBLE_STATIC_INVENTORY} ansible/slurm-cluster-04-configure-slurm-daemons.yml
ansible-playbook -e @${CONFIG_FILE} -i ${ANSIBLE_STATIC_INVENTORY} ansible/slurm-cluster-05-configure-user-accounts.yml
