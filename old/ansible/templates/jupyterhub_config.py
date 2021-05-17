import batchspawner

c = get_config()

#c.JupyterHub.ssl_cert = '/shared/srv/jupyterhub/mycert.pem'
#c.JupyterHub.ssl_key = '/shared/srv/jupyterhub/mycert.key'

#c.JupyterHub.cookie_secret_file = '/shared/srv/jupyterhub/jupyterhub_cookie_secret'
#c.ConfigurableHTTPProxy.auth_token = '/shared/srv/jupyterhub/proxy_auth_token'

c.JupyterHub.bind_url = 'http://127.0.0.1:8000'
#c.JupyterHub.bind_url = 'http://0.0.0.0'

c.JupyterHub.db_url = 'postgresql://jupyterhub:{{ jupyterhub_postgresdb_password }}@127.0.0.1/jupyterhub'

c.JupyterHub.hub_ip = 'slurm-login'

c.PAMAuthenticator.open_sessions = False
c.LocalAuthenticator.create_system_users = True
#c.Authenticator.whitelist = {'user01'}

c.Spawner.default_url = '/lab'
c.Spawner.http_timeout = 120
c.Spawner.start_timeout = 300 # timeout after 5 mintues waiting in queue

# not sure which of these are necessary, if any
c.Spawner.env_keep = ['PATH', 'PYTHONPATH', 'CONDA_ROOT', 'CONDA_DEFAULT_ENV', 'VIRTUAL_ENV', 'LANG', 'LC_ALL','JUPYTERHUB_BASE_URL','JPY_API_TOKEN','JUPYTERHUB_API_URL','JUPYTERHUB_CLIENT_ID','JUPYTERHUB_HOST','JUPYTERHUB_API_TOKEN','HOME','JUPYTERHUB_USER','JUPYTERHUB_OAUTH_CALLBACK_URL','SHELL','USER','JUPYTERHUB_SERVICE_PREFIX','LOADEDMODULES','LD_LIBRARY_PATH','LIBRARY_PATH','MODULEPATH']

c.JupyterHub.spawner_class = 'batchspawner.SlurmSpawner'
c.BatchSpawnerBase.req_partition='compute'
c.BatchSpawnerBase.req_runtime='24:00:00'
c.BatchSpawnerBase.req_srun=''
c.BatchSpawnerBase.req_cluster = 'slurm_cluster' # probably only necessary for federated clusters


{% raw %}
c.BatchSpawnerBase.batch_script = """#!/bin/bash -l
#SBATCH --output=jupyterhub_slurmspawner_%j.log
#SBATCH --job-name=spawner-jupyterhub
#SBATCH --chdir={{homedir}}
#SBATCH --no-requeue
#SBATCH --export=ALL
##SBATCH --exclusive
#SBATCH --partition={{partition}}
{% if runtime    %}{% if runtime[0] %}#SBATCH --time={{runtime[0]}}{% endif %}{% endif %}
mymem={{memory}}
echo $mymem
{% if memory     %}#SBATCH --mem={{memory}}{% endif %}
ncores_int=$(expr {{nprocs}})
{% if nprocs     %}#SBATCH --cpus-per-task=$ncores_int{% endif %}

trap 'echo SIGTERM received' TERM
#{{prologue}}
#unset XDG_RUNTIME_DIR # necessary?

#source /etc/profile.d/lmod.sh # necessary?
#ml gnu8/8.3.0
#ml openmpi3/3.1.4
#ml py3-mpi4py/3.0.2

export PATH=/shared/jupyterhub/bin/:$PATH
source /shared/jupyterhub/bin/activate

#jupyter serverextension enable --py nbresuse --sys-prefix
#jupyter nbextension enable --py nbresuse --sys-prefix
#jupyter serverextension enable --py jupyterlab_code_formatter
#jupyter serverextension enable --py dask_labextension
#jupyter serverextension enable --py jupyter_server_proxy
#jupyter serverextension enable --py jupyterlab
##export MEM_LIMIT=65498251264

#source ~/.jupyterhub.env #this allows users to set env variables, load modules, etc

which jupyterhub-singleuser
{% if srun %}{{srun}} {% endif %}{{cmd}}
echo "jupyterhub-singleuser ended gracefully"
"""
{% endraw %}

#c.JupyterHub.template_paths = ['/opt/rh/rh-python36/root/usr/share/jupyterhub/templates/cscs/'] #where much of the web front end is defined

c.Spawner.options_form = """
        <hr>
        <br><label for "reservation">Advanced reservation</label>
        <input name="reservation"></input>
        <br>
        <br><label for="nprocs">Number of cores</label>
        <select name="nprocs">
          <option value="1">1</option>
          <option value="2">2</option>
          <option value="4">4</option>
        </select>
        <br><label for="memory">Memory</label>
        <select name="memory">
          <option value="4G">4G</option>
          <option value="8G">8G</option>
        </select>
        <br><label for="runtime">Job duration</label>
        <select name="runtime">
          <option value="1:00:00">1 hour</option>
          <option value="2:00:00">2 hours</option>
          <option value="4:00:00">4 hours</option>
          <option value="8:00:00">8 hours</option>
          <option value="12:00:00">12 hours</option>
          <option value="24:00:00">24 hours</option>
        </select>
        <br><label for="account">Project id (leave empty for default)</label>
         <input name="account"></input>
        <br>
                <hr>
        """


# https://github.com/jupyterhub/jupyterhub/issues/2541
# the Hub must be restarted to reload configuration. (including addition of new users)
# If I restart Jupyterhub and at the same time I have existing users logged-in and doing work, will they lose their non-saved work?
# This will depend on configuration, but usually no. This will depend on the values for JupyterHub.cleanup_servers and Proxy.should_start.
# By default, these are both True, in which case shutting down the Hub will shut down everything.
# However, in a production deployment, these should typically both be False, so that restarting the Hub has no disruption for users who are already running their servers at all.

# service fails to start if these are enabled:
#c.JupyterHub.cleanup_servers = False
#c.Proxy.should_start = False
