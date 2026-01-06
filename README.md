# sciCORE courses

OpenTofu and ansible code used to boot and configure the infrastructure for the sciCORE courses

## Setting up the control host

### OpenTofu

Install OpenTofu (tested with version 1.9.1)

### Ansible and Openstack client

```bash
$> git clone https://github.com/scicore-unibas-ch/ansible-playbook-scicore-courses-cloud.git
$> cd ansible-playbook-scicore-courses-cloud
$> python3 -m venv .venv
$> source .venv/bin/activate
$> pip install -U pip
$> pip install -r ansible/requirements.txt
$> source ~/your/openstack-openrc.sh
$> openstack server list
```

## Booting the machines (OpenTofu)

Configure the cluster by editing file `opentofu/variables.tf`

```bash
$> cd opentofu/
$> tofu plan
$> tofu apply
$> openstack server list
``` 

## Configuring the machines (ansible)

```bash
$> cd ansible/
$> ansible-galaxy role install -r requirements.yml -p roles/
$> ansible course -m shell -a 'uname -r'
$> ansible-playbook playbooks/apt-dist-upgrade.yml
$> ansible-playbook playbooks/site.yml
$> ansible-playbook playbooks/cvmfs-presync.yml
$> ansible-playbook playbooks/rstudio.yml
```

## Stop and destroy all the machines

```bash
$> cd opentofu/
$> tofu destroy
```
