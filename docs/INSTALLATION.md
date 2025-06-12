## 🔧 Installation Guide (Ansible-based External IaC VM)

### Prerequisites:
- Fundamental knowledge of Qubes OS, Linux, and Ansible.
- Backup of important data prior to deployment.

## Step-by-Step Setup:

### 1. Create and configure Management VM (`sys-mgmt`):

In **dom0**, execute:
```bash
qvm-create sys-mgmt --template fedora-37 --label yellow --netvm none
```

### 2. Configure Secure Dom0 ↔ sys-mgmt qrexec Communication  

**In dom0**, create restricted RPC script `/etc/qubes-rpc/dom0.exec_qvm_command`:
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

Create qrexec policy file to whitelist sys-mgmt explicitly at `/etc/qubes-rpc/policy/dom0.exec_qvm_command`:
With the following line: 
```mgmt-vm dom0 allow```

### 3. Run playbook to deploy 

Inside **sys-mgmt**, install Ansible/Git, and fetch IaC repository:
```bash
sudo dnf install -y ansible git
git clone https://github.com/dzzy/QubesAIRouter
cd QubesAIRouter/ansible
```
ansible-playbook -i inventory.ini playbooks/bootstrap.yml | tee bootstrap.log

### 4. 