# salt/roles/dhcp/template.sls

qubes.vm:
  - name: fedora-dhcp
  - present: True
  - template: fedora-41-minimal
  - clone: fedora-41-minimal
  - label: green

qubes.vm.tag:
  - name: fedora-dhcp
  - add:
      - dhcp-template

qubes.vm.pkg:
  - name: fedora-dhcp
  - install:
      - dnsmasq
      - tcpdump
      - iproute
      - NetworkManager