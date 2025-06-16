# /salt/qairouter/roles/dom0/qrexec.sls

/etc/qubes-rpc/policy/sys-config.get-dns-config:
  file.managed:
    - source: salt://dom0/policies/sys-config.get-dns-config
    - user: root
    - group: root
    - mode: 0644

/etc/qubes-rpc/policy/sys-config.get-dhcp-config:
  file.managed:
    - source: salt://dom0/policies/sys-config.get-dhcp-config
    - user: root
    - group: root
    - mode: 0644