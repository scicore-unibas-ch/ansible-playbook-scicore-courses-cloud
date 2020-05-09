
```
ansible-playbook -e @config/slurm_cluster.yml ansible/00-boot-slurm-cluster-openstack.yml
ansible-playbook -e @config/slurm_cluster.yml ansible/01-configure-nfs-server.yml
ansible-playbook -e @config/slurm_cluster.yml ansible/02-configure-slurm-cluster.yml
```
