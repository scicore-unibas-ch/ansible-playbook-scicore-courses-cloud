
```
ansible-playbook -e @config/slurm_cluster.yml 00-boot-slurm-cluster-openstack.yml
```
ansible-playbook -e @config/slurm_cluster.yml ansible/01-configure-nfs-server.yml
