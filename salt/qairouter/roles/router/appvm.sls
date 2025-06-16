# /salt/qaurouter/roles/router/appvm.sls

qubes.vm:
  - name: sys-router
  - present: True
  - template: fedora-router
  - label: yellow
  - netvm: sys-net
  - provides_network: True

# Add the 'role-router' tag
qubes.vm.tag:
  - name: sys-router
  - add:
      - role-router

qubes.vm.file:
  - name: /rw/config/nmcli-vlan-setup.sh
  - vm: sys-router
  - source: salt://roles/router/files/router-setup.sh.j2
  - template: jinja
  - context:
      vifs: {{ pillar['router']['subnets'] }}
  - mode: '0755'

qubes.vm.service:
  - name: vlan-setup
  - enabled: True