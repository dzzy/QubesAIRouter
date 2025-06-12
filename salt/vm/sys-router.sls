sys-router:
  qvm.present:
    - template: fedora-37-minimal
    - label: blue
    - netvm: sys-net
    - memory: 2048