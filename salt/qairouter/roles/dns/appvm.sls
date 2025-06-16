# salt/qairouter/roles/dns/appvm.sls

qubes.vm:
  - name: dns-dvm
  - present: True
  - template: fedora-dns
  - label: yellow
  - netvm: sys-router

qubes.vm.tag:
  - name: dns-dvm
  - add:
      - role-dns

qubes.vm.file:
  - name: /rw/config/dnscrypt-proxy.toml
  - vm: dns-dvm
  - source: salt://roles/dns/files/dnscrypt-proxy.toml
  - mode: '0644'

qubes.vm.file:
  - name: /rw/config/dnsmasq.conf
  - vm: dns-dvm
  - source: salt://roles/dns/files/dnsmasq.conf
  - mode: '0644'

qubes.vm.service:
  - name: doh-dns
  - enabled: True