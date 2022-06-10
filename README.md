[![ansible-lint](https://github.com/scicore-unibas-ch/ansible-playbook-scicore-courses-cloud/actions/workflows/ansible-lint.yml/badge.svg)](https://github.com/scicore-unibas-ch/ansible-playbook-scicore-courses-cloud/actions/workflows/ansible-lint.yml)
[![yamllint](https://github.com/scicore-unibas-ch/ansible-playbook-scicore-courses-cloud/actions/workflows/yamllint.yml/badge.svg)](https://github.com/scicore-unibas-ch/ansible-playbook-scicore-courses-cloud/actions/workflows/yamllint.yml)


# Cloud playbooks

Ansible playbooks to boot resources in the cloud for the sciCORE courses

## Short description on how these playbooks work

Inside the [ansible](ansible) folder you will find different playbooks for the different scicore courses.
Playbooks with same name prefix belong to the same course. e.g. these are the playbooks to boot a slurm cluster

```
ansible/slurm-cluster-01-boot-openstack.yml
ansible/slurm-cluster-02-common.yml
ansible/slurm-cluster-03-configure-nfs.yml
ansible/slurm-cluster-04-configure-slurm-daemons.yml
ansible/slurm-cluster-05-configure-user-accounts.yml
ansible/slurm-cluster-06-configure-rstudio.yml
ansible/slurm-cluster-07-configure-monitoring.yml
```

First playbook will use Terraform to boot the cloud the resources and will create an ansible static inventory. 

Rest of the playbooks will use static inventory to connect to the cloud resources and configure them.

## Variables naming convention

If a variable starts with prefix `local_` it means it's a "playbook var" defined only for this playbook.

If a variable has any other prefix different from `local_` it's a role variable. It's used to override a var in one of the roles in [ansible/requirements.yml](ansible/requirements.yml)

# How to use these playbooks

## Prepare the environment

### Download this git repo

```
$> git clone https://github.com/scicore-unibas-ch/ansible-playbook-scicore-courses-cloud.git
$> cd ansible-playbook-scicore-courses-cloud
```

### Install the required Python dependencies in a virtualenv

Tested with Python-3.6.6:

```
$> virtualenv venv_cloud
$> source venv_cloud/bin/activate
(venv_cloud)$> pip install -r requirements.txt
```

### Install the required ansible dependencies
```
(venv_cloud)$> ansible-galaxy role install -r ansible/requirements.yml -p ansible/roles/
(venv_cloud)$> ansible-galaxy collection install -r ansible/requirements.yml -p ansible/collections/
```

### Download terraform and add it to your PATH

```
$> mkdir ~/bin/
$> curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.15.3/terraform_0.15.3_linux_amd64.zip
$> unzip /tmp/terraform.zip -d ~/bin/
$> export PATH=~/bin:$PATH
```

### Configure authentication with the Cloud environment

Go to your cloud webui and download the auth RC file. In openstack this is usually located in the top right corner of the webui.

```
(venv_cloud)$> source openstack_auth.rc
(venv_cloud)$> source <(openstack complete)
```

At this point you should be able to interact with the cloud API from the CLI. Try these commands. They will be useful to define
you config file:

```
(venv_cloud)$> openstack image list
(venv_cloud)$> openstack flavor list
(venv_cloud)$> openstack network list
(venv_cloud)$> openstack server list
```

If these commands don't work double check that your openstack login info is correct and try to execute `openstack image list -v` to get a more verbose output

### Prepare you config file
```
(venv_cloud)$> cp config/slurm_cluster_switch_cloud.yml.example config/slurm_cluster_switch_cloud.yml
```

Now edit `config/slurm_cluster_switch_cloud.yml` and adapt it to your needs based on the output from previous commands. Most variables are self-descriptive.
TO-DO: Improve the config docs

**when defining the number of nodes to boot or the disk size double check in the webui if your cloud quota is big enough**

## Booting a Slurm cluster

```
$> ./slurm-cluster.sh
```

## Connecting to the slurm cluster

```
$> ssh -F ~/.ssh/slurm_cluster_cloud.cfg slurm-login
```

## Running an interactive command in every machine in the slurm cluster

From you ansible control host:

```
$> ansible slurm_cluster_all -i ansible/inventory/slurm_cluster -m shell -a 'uname -r'

$> ansible slurm_cluster_all -i ansible/inventory/slurm_cluster -m shell -a 'yum -y install htop'
```

## Delete the Slurm cluster

```
$> cd terraform/slurm-cluster-openstack/
$> terraform destroy
$> openstack keypair delete slurm_cluster_cloud
```
