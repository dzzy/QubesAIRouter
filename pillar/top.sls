# pillar/top.sls
# pillar/top defines which base receives access to which config files/secrets

base:
  dom0:
    - roles.dom0
  'tag:router-dvm':
    - netconfig
  'tag:dns-dvm':
    - dns
  'tag:router-fedora':
    - roles.router-template