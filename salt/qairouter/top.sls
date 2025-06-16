# salt/qairouter/top.sls

base:
  dom0:
    - roles.router
    - roles.dns
    - roles.dhcp