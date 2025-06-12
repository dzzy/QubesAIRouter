/etc/qubes-rpc/policy/sys-config.get-dev-config:
  file.managed:
    - source: salt://dom0/policies/sys-config.get-dev-config
    - user: root
    - group: root
    - mode: 0644

/etc/qubes-rpc/policy/sys-config.get-router-config:
  file.managed:
    - source: salt://dom0/policies/sys-config.get-router-config
    - user: root
    - group: root
    - mode: 0644

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

/etc/qubes-rpc/policy/sys-config.get-vpn-config:
  file.managed:
    - source: salt://dom0/policies/sys-config.get-vpn-config
    - user: root
    - group: root
    - mode: 0644

/etc/qubes-rpc/policy/sys-config.get-lan-config:
  file.managed:
    - source: salt://dom0/policies/sys-config.get-lan-config
    - user: root
    - group: root
    - mode: 0644

/etc/qubes-rpc/policy/sys-ai.run-ollama:
  file.managed:
    - source: salt://dom0/policies/sys-ai.run-ollama
    - user: root
    - group: root
    - mode: 0644