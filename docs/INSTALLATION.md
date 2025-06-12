## 🔧 Installation Guide (Ansible-based External IaC VM)

### Prerequisites:
- A working knowledge of Linux and Qubes OS basics.
- A dedicated, isolated management VM (`sys-mgmt`) with Ansible and Git.
- Backup important data prior to installation and teardown.

### Step-by-Step Setup:

### 1. Create and Configure the Management VM (`sys-mgmt`):

In dom0, create the isolated VM:

```bash
qvm-create sys-mgmt --template fedora-37 --label yellow --netvm none
```

### 2. Install Ansible and Git (inside sys-mgmt):

Open terminal within `sys-mgmt` and run:
```bash
sudo dnf install -y ansible git
```

Clone the repository inside `sys-mgmt`:
```bash
git clone https://github.com/dzzy/QubesAIRouter
cd QubesAIRouter
```

### 3. Setup Secure qrexec RPC from dom0 to sys-mgmt:

In dom0, place the following qrexec rpc script in `/etc/qubes-rpc/dom0.exec_qvm_command`:

```bash
#!/bin/sh
case "$1" in
    qvm-create*|qvm-remove*|qvm-prefs*|qvm-clone*|qvm-pci*)
        $1 ;;
    *)
        echo "Command Not Allowed" >&2
        exit 1 ;;
esac
```

Make executable:
```bash
sudo chmod +x /etc/qubes-rpc/dom0.exec_qvm_command
```

Policy file (`/etc/qubes-rpc/policy/dom0.exec_qvm_command`):
```bash
sys-mgmt dom0 allow
```

You can also copy the file created at `./config/qrexec/qrexec.config` into dom0 and rename it accordingly.

### 4. Review Infrastructure configurations (`vars/main.yml`):

Verify your infrastructure setup parameters (template names, networking, VLANs, GPU PCI, etc.):
```bash
vim vars/main.yml
```

### 5. Execute Bootstrap Playbook (from sys-mgmt terminal):

Run Ansible bootstrap playbook, logging both output and errors clearly:
```bash
ansible-playbook -i inventory.ini playbooks/bootstrap.yml | tee bootstrap.log
```

**Note:** This execution could take several minutes depending on your hardware and network speed.

### 6. Verify Installation:

Check via Qubes Manager that your VMs created correctly, network assigned, GPU passthrough configured, etc.

---

## ♻️ Reverting/Removing the Setup

To remove generated VM assets using the provided teardown playbook:
```bash
ansible-playbook -i inventory.ini playbooks/teardown.yml | tee teardown.log
```

**Important:** Teardown permanently removes VMs/assets. Always backup necessary information first.
