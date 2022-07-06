from fabric import task

import os

# Populates hosts by environ variable
if os.environ.get("STAGE") == "test":
    default_hosts = ['joy-web1']
else:
    default_hosts = ['joy-web1', 'joy-web2']

from fabric.main import program
if not program.core[0].args.hosts.value:
    program.core[0].args.hosts.value = ",".join(default_hosts)

