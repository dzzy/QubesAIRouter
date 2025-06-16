# /salt/roles/router/router-template.sls

qubes.vm:
  - name: fedora-router
  - present: True
  - template: fedora-41-minimal
  - clone: fedora-41-minimal
  - label: green

qubes.vm.tag:
  - name: fedora-router
  - add:
      - router-template

qubes.vm.pkg:
  - name: fedora-router
  - install:
    - dnsmasq
    - NetworkManager
    - iproute
    - nm-connection-editor
    - bridge-utils
    - tcpdump