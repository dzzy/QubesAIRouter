#/pillar/qairouter/netconfig.sls 
subnets:
  dns: 
    vif: vif-dns
    subnet: 192.168.5.0/24
  dhcp: 
    vif: vif-dhcp
    subnet: 192.168.6.0/24
  vlan10:
    vif: vif10
    subnet: 192.168.10.0/24
    dhcp_range: 192.168.10.50,192.168.10.100
  vlan20:
    vif: vif20
    subnet: 192.168.20.0/24
    dhcp_range: 192.168.20.50,192.168.20.100
  vlan30:
    vif: vif30
    subnet: 192.168.30.0/24
    dhcp_range: 192.168.30.50,192.168.30.100
  vlan40:
    vif: vif40
    subnet: 192.168.40.0/24
    dhcp_range: 192.168.40.50,192.168.40.100
  vlan50:
    vif: vif50
    subnet: 192.168.50.0/24
    dhcp_range: 192.168.50.50,192.168.50.100
  vlan60:
    vif: vif60
    subnet: 192.168.60.0/24
    dhcp_range: 192.168.60.50,192.168.60.100
  vlan70:
    vif: vif70
    subnet: 192.168.70.0/24
    dhcp_range: 192.168.70.50,192.168.70.100
  vlan80:
    vif: vif80
    subnet: 192.168.80.0/24
    dhcp_range: 192.168.80.50,192.168.80.100
  vlan90:
    vif: vif90
    subnet: 192.168.90.0/24
    dhcp_range: 192.168.90.50,192.168.90.100
  vlan100:
    vif: vif100
    subnet: 192.168.100.0/24
    dhcp_range: 192.168.100.50,192.168.100.100