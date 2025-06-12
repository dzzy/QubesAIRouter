## 📌 Installation:

1. **Create `sys-mgmt` VM:**  
   `qvm-create sys-mgmt --template fedora-37 --netvm none`

2. **Install Ansible inside Management VM:**  
   `sudo dnf install -y ansible git`

3. **Clone IaC Repo to sys-mgmt:**  
   `git clone <your_repo_url>`

4. **Setup dom0 rpc functions/policies as above**, securely enabling defined commands.

### 🚀 Deploy infrastructure (from `sys-mgmt`):

```bash
cd QubesAIRouter
ansible-playbook -i inventory.ini playbooks/bootstrap.yml | tee bootstrap.log
```

### ♻️ Teardown infrastructure (from `sys-mgmt`):

```bash
ansible-playbook -i inventory.ini playbooks/teardown.yml | tee teardown.log
```