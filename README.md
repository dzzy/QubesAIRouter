# Qubes AI Router

## 🌟 Benefits and Philosophy

This project provides a secure, modular, and powerful AI-assisted security router environment built on Qubes OS. It combines cutting-edge AI with strong security practices that respect your privacy while delivering robust automation and analysis capabilities.

Key advantages include:

- **Service Separation**: Each core router function (DNS, DHCP, VPN, VLAN, etc.) runs in its own VM. This isolates vulnerabilities in one service from affecting others and reduces the system's overall attack surface.
- **Least Privilege by Design**: Dedicated VMs have only the permissions they need, minimizing the blast radius of any compromise.
- **Privacy-First AI**: All AI inference occurs locally in isolated VMs, with no cloud dependencies.
- **GPU-Accelerated**: PCI passthrough enables hardware acceleration for fast AI inference.
- **Modular Architecture**: Qubes VM separation keeps logs, configurations, and AI components securely isolated.
- **Anomaly Detection**: Continuous log parsing and contextual analysis detect suspicious activity in real time.
- **Self-Sovereign Intelligence**: Your data and insights remain yours—no third-party services or data sharing.
- **Isolated Interactions**: VMs communicate only through controlled interfaces (like Qubes qrexec services and API endpoints), with no direct device or file sharing. This limits lateral movement even if one VM is compromised.
- **Attack Path Mitigation**: Segregating services contains common attack vectors (e.g., DHCP spoofing, DNS poisoning, VPN tunnel compromise) within their respective VMs, preserving system integrity.

## 🏗️ VM Architecture Overview

| VM Name      | Purpose                                    
|--------------|--------------------------------------------
| dom0         | Qubes management domain; oversees VM lifecycle, security policies, and system updates
| sys-ai*      | Inference engine running Ollama + GPU passthrough (Phi3, Mistral, etc.)
| sys-dev      | Development environment with VS Code, LangChain, scripting tools, API calls to sys-ai
| sys-config   | Centralized storage for all configuration files, YAML logs, DHCP leases, DNS filter lists, firewall/router configs, and VLAN settings in a Git-managed repo
| sys-router*  | Gateway VM for traffic routing (DHCP, DNS, VPN, VLANs)
| sys-dns*     | Disposable DNS server VM
| sys-dhcp*    | Disposable DHCP server VM
| sys-vpn*     | Disposable VPN VM (optional)
| sys-firewall | Disposable Firewall VM controlling upstream traffic
| sys-lan      | Disposable VM handling VLAN tagging 
( * = custom template)

### 🧩 Connectivity
- `sys-dev` sends prompt or code requests to `sys-ai` (Ollama API).
- `sys-dev` pulls config files from `sys-config` using qrexec or qvm-copy.
- `sys-config` has **no direct network access**; it serves as a secure, read-only config storage VM.
- VMs’ networking is routed via `sys-router`.
- VMs communicate securely using custom **qrexec** services configured in `dom0` to enforce strict access controls and minimize attack surface.

## Getting Started
To get started, ensure you have a working knowledge of Linux and Qubes OS fundamentals (Disposable VMs, Templates, etc.). Follow the hardware and virtualization setup steps below to prepare your environment, then proceed with AI environment setup and integration.

## dom0 Responsibilities and qrexec Configuration
The `dom0` domain is the trusted administrative domain in Qubes OS responsible for managing VM lifecycles, enforcing security policies, and configuring inter-VM communication. To enable secure interactions between VMs in this AI router setup, custom **qrexec** services are defined and managed within `dom0`. These services act as controlled interfaces allowing specific commands or data transfers while preventing unauthorized access.
By carefully managing qrexec services in `dom0`, this AI router architecture maintains strong isolation between components while enabling necessary, secure inter-VM communication.

# Configuration Overview

### 🛠️ Hardware and Virtualization Setup
- Use an NVIDIA 30xx+ GPU for best compatibility with CUDA 12.
- Pass through the GPU (and audio controller) to a dedicated HVM-based `sys-ai` VM.
- Disable dynamic memory balancing in Qubes VM settings.
- Enable strict PCI reset in Qubes global settings to ensure safe GPU resets.
- Disable the `nouveau` driver by blacklisting it in `/etc/default/grub` and regenerating GRUB config.
- Install NVIDIA CUDA drivers from `https://developer.nvidia.com/cuda-downloads`.
- Confirm NVIDIA drivers are in use inside `sys-ai` (`nvidia-smi`, `lsmod`, `lspci`).
- Install `nvidia-smi` (`sudo dnf install -y nvidia-smi`).

### 🧰 AI Environment Setup
- Download and install [Ollama](https://ollama.ai).
- Download and install CUDA 
- Download and install NVIDIA Drivers
- Confirm NVIDIA driver installation (`nvidia-smi` shows GPU).
- Optionally install additional LLM frameworks:
  - NVIDIA’s TensorRT-LLM toolkit.
  - [lmdeploy](https://github.com/InternLM/lmdeploy) for efficient serving.
- Run a test query to verify everything is working:
  ```bash
  ollama run llama3 "Hello AI Router!"
  ```

### Setting Up qrexec Policies and Services ###
1. **Define Custom qrexec Services:**  
   Create service scripts under `/etc/qubes-rpc/` in `dom0` that specify allowed commands or data exchanges between VMs (e.g., fetching config files from `sys-config` or sending AI prompts to `sys-ai`).
2. **Configure Policy Files:**  
   Edit `/etc/qubes-rpc/policy` in `dom0` to specify which VMs can invoke each service and under what conditions. This ensures least privilege and auditability.
3. **Reload qrexec Daemon:**  
   After changes, reload the qrexec daemon or reboot `dom0` to apply new policies.
4. **Testing and Validation:**  
   Verify that only authorized VMs can access the services and that communication behaves as expected without exposing unnecessary privileges.

### 🗂️ Config VM and Centralized Data Storage
We’re consolidating logs, DHCP leases, DNS filter lists, firewall rules, router configurations, and netVM VLAN configurations into the dedicated `sys-config` VM. This ensures:

- **Single source of truth**: All critical configs and historical data are tracked in one place.
- **Disposable service VMs**: Services like DHCP, DNS, VPN, and firewall remain stateless, pulling their configuration from `sys-config` as needed.
- **Read-only access**: Service VMs can **read** from `sys-config` but cannot **write** to it. This prevents accidental or malicious modification of configuration data.
- **Version control**: We use Git inside `sys-config` to track changes, enabling easy rollback and history tracking.

This approach removes the need for a separate log VM (`sys-logs`) while improving security and simplicity.

### 2️⃣ Enable AI Router Capabilities
- Connect the AI VM (`sys-ai`) to the core Qubes router VM (`sys-router` or equivalent).
- Set up log file sharing or API endpoints for logs from:
  - Network devices.
  - Qubes firewall VM.
  - Config backups.

### 3️⃣ Integrate MCP Tools and Automation
- (Optional) Integrate LLM APIs locally with your IDE:
- Determine the model size and context size needed for your AI workflows.
- Set up a Python environment for LLM orchestration:
  ```bash
  python3 -m venv ai-env
  source ai-env/bin/activate
  ```
- Install **LangChain** for structured prompt interactions:
  ```bash
  pip install langchain
  ```
- Use MCP tools (Model Context Protocol) to:
  - Expose logs and config files as structured input.
  - Parse and store historical context.
- Automate prompt-based analysis and anomaly detection.
- Possibly deploy:
  - A vector database (like Qdrant or Weaviate) for historical log embeddings.

## 🧩 Possible Tooling Choices
- **LLM backend**: Ollama, LMDeploy, vLLM.
- **Prompt engineering / orchestration**: LangChain, LlamaIndex.
- **Vector DB**: Qdrant, Milvus.
- **Anomaly detection**: Use model context + external rules.

## Configuration Scripts and Files: ##
- VM and Template Creation
- dom0 qrexec services
- qrexec policy file
- Firewall 
- DHCP configuration
- DNS Configuration
- VLAN Configuration
- LLM Setup

### 4️⃣ Security & Privacy Considerations
- Audit and harden GPU passthrough access.
- Verify strong isolation between the AI VM and sensitive config VMs.
- (Optional) Move model downloads behind Tor (`sys-whonix`) for better anonymity.

## Project File Structure

```
QubesAIRouter/
├── README.md
├── scripts/
│   ├── create_vms.sh
│   ├── setup_qrexec_services.sh
│   ├── configure_firewall.sh
│   ├── deploy_dhcp_dns.sh
│   └── setup_llm_env.sh
├── dom0/
│   ├── qubes-rpc/
│   │   ├── sys-config.get-config
│   │   ├── sys-ai.run-ollama
│   │   └── policy
├── sys-config/
│   ├── configs/
│   │   ├── firewall.rules
│   │   ├── dhcpd.conf
│   │   ├── named.conf
│   │   └── vlan_settings.yaml
│   ├── logs/
│   └── leases/
├── sys-ai/
│   └── docker/
│       └── Dockerfile
├── sys-dev/
│   └── langchain_prompts/
└── docs/
    └── architecture.png
```