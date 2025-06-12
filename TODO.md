# to-do list

### Configuration Scripts

- Automate template customization with scripts to install necessary packages and configure services inside each VM.

#### dom0 qrexec Service Scripts
- Example service script `/etc/qubes-rpc/sys-config.get-config`:
```bash
#!/bin/bash
# This script serves configuration files to authorized VMs
CONFIG_PATH="/home/user/configs/$1"
if [[ -f "$CONFIG_PATH" ]]; then
    cat "$CONFIG_PATH"
else
    echo "File not found" >&2
    exit 1
fi
```
- Make sure the script is executable and owned by root.

#### qrexec Policy Files
- Add entries in `/etc/qubes-rpc/policy`:
```
sys-dev sys-config sys-config.get-config ask
sys-router sys-config sys-config.get-config ask
sys-ai sys-dev sys-ai.run-ollama ask
```
- Use `ask` or `allow` depending on desired security posture.

#### Firewall Rules and Configurations
- Store firewall rules in `sys-config` and load them dynamically in `sys-firewall` VM.
- Example firewall rule file:
```bash
# Allow DNS and DHCP traffic only from internal VMs
iptables -A INPUT -s 10.137.0.0/16 -p udp --dport 53 -j ACCEPT
iptables -A INPUT -s 10.137.0.0/16 -p udp --dport 67:68 -j ACCEPT
```

#### DHCP and DNS Configurations
- Store DHCP leases and config files in `sys-config`.
- Use scripts in `sys-dhcp` and `sys-dns` that pull config files on startup from `sys-config` via qrexec or qvm-copy.

#### Optional LLM Setup Scripts
- Automate Python environment setup and package installation in `sys-dev`:
```bash
#!/bin/bash
python3 -m venv ~/ai-env
source ~/ai-env/bin/activate
pip install --upgrade pip
pip install langchain ollama-client
```
