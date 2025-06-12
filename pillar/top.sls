# pillar/top.sls
base:
  dom0:
    - roles.dom0
  'tag:router-dvm':
    - netconfig
  'tag:router-fedora':
    - roles.router-template