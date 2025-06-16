# salt/roles/dhcp/appvm.sls

qubes.vm:
  - name: dhcp-dvm
  - present: True
  - template: fedora-dhcp
  - label: yellow
  - netvm: sys-router

qubes.vm.tag:
  - name: dhcp-dvm
  - add:
      - role-dhcp

qubes.vm.file:
  - name: /rw/config/dhcp-dnsmasq.conf
  - vm: dhcp-dvm
  - source: salt://roles/dhcp/files/dhcp-dnsmasq.conf
  - mode: '0644'

qubes.vm.service:
  - name: dhcp-server
  - enabled: True