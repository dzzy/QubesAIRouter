{% set network = pillar.get('network') %}

eth0.10:
  network.managed:
    - enabled: True
    - type: vlan
    - vlan_id: 10
    - device: eth0
    - ipaddr: {{ network.vlan10_subnet.split('/')[0] }}
    - netmask: 255.255.255.0