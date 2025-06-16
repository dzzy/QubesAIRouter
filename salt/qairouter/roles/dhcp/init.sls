# /salt/qairouter/roles/dns/init.sls

include:
  - roles.dhcp.template
  - roles.dhcp.appvm