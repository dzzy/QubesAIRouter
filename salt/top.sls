#/salt/top.sls

base:
  dom0:
    - roles.router
  sys-router:
    - roles.router