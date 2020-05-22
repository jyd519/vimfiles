# Populates hosts by environ variable
if os.environ.get("STAGE") == "test":
    default_hosts = ['joy-web1']
else:
    default_hosts = ['joy-web1', 'joy-web2']

if not program.core[0].args.hosts.value:
    program.core[0].args.hosts.value = ",".join(default_hosts)
