# Cloud playbooks

Ansible playbooks to boot resources in the clooud for the sciCORE courses

## Prepare the environment

### Download this git repo

```
$> git clone https://github.com/scicore-unibas-ch/ansible-playbook-slurm-cluster-cloud.git
$> cd ansible-playbook-slurm-cluster-cloud
```

### Install the required software

Tested with Python-3.6.6:

```
$> virtualenv venv_cloud
$> source venv_cloud/bin/activate
(venv_cloud)$> pip install ansible==2.9.13 python-openstackclient
(venv_cloud)$> ansible-galaxy role install -r ansible/requirements.yml -p ansible/roles/
```

### Configure authentication with the Cloud environment

Go to your cloud webui and download the auth RC file. In openstack this is usually located in the top right corner of the webui.

```
(venv_cloud)$> source openstack_auth.rc
(venv_cloud)$> source <(openstack complete)
(venv_cloud)$> openstack network list
```

At this point you should be able to interact with the cloud API from the CLI. Try these commands. They will be useful to define
you config file:

```
(venv_cloud)$> openstack image list
(venv_cloud)$> openstack flavor list
(venv_cloud)$> openstack network list
```

### Prepare you config file
```
(venv_cloud)$> cp config/slurm_cluster_switch_cloud.yml.example config/slurm_cluster_switch_cloud.yml
```

Now edit `config/slurm_cluster_switch_cloud.yml` and adapt it to your needs based on the output from previous commands. Most variables are self-descriptive.
TO-DO: Improve the config docs

## Boot the cluster
```
ansible-playbook -e @config/slurm_cluster_switch_cloud.yml ansible/00-boot-slurm-cluster-openstack.yml
ansible-playbook -i ansible/inventory/hosts -e @config/slurm_cluster_switch_cloud.yml ansible/01-configure-nfs-server.yml
ansible-playbook -i ansible/inventory/hosts -e @config/config/slurm_cluster_switch_cloud.yml ansible/02-configure-slurm-cluster.yml
```
