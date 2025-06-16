# salt/qairouter/roles/dns/template.sls

qubes.vm:
  - name: fedora-dns
  - present: True
  - template: fedora-41-minimal
  - clone: fedora-41-minimal
  - label: green

qubes.vm.tag:
  - name: fedora-dns
  - add:
      - dns-template

qubes.vm.pkg:
  - name: fedora-dns
  - install:
      - dnscrypt-proxy
      - dnsmasq
      - ca-certificates

qubes.vm.file:
  - name: /lib/systemd/system/doh-dns.service
  - vm: dns-dvm
  - source: salt://roles/dns/files/doh-dns.service
  - mode: '0644'

qubes.vm.service:
  - name: doh-dns
  - enabled: True