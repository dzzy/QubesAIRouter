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


# Configuration Overview

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
- Provide access to logs and relevant network data to the MCP server through the `sys-dev` VM, avoiding direct log file sharing or pushing logs between VMs. This ensures logs are exposed securely and controlled via `sys-dev` APIs rather than shared directly to the LLM. This approach removes the need for a separate log VM (`sys-logs`) while improving security and simplicity.

### 2️⃣ Enable AI Router Capabilities
- Set up API endpoints for logs from:
  - Network devices.
  - Qubes firewall VM.
  - Config backups.

### 3️⃣ Integrate MCP Tools and Automation
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
- Deploy a vector database (like Qdrant or Weaviate) for historical log embeddings.
  **Note:** Logs and relevant network data are only exposed to the MCP server through the `sys-dev` VM. There is no direct log file sharing or pushing of logs from the service VMs (such as DHCP, DNS, VPN, firewall) to the MCP server. This design ensures that all log access is mediated and controlled via `sys-dev` APIs, maintaining strict security boundaries and minimizing attack surface.

## 🧩 Possible Tooling Choices
- **LLM backend**: Ollama, LMDeploy, vLLM.
- **Prompt engineering / orchestration**: LangChain, LlamaIndex.
- **Vector DB**: Qdrant, Milvus.
- **Anomaly detection**: Use model context + external rules.

## Configuration Scripts and Files: ##
- VM and Template Creation
- dom0 qrexec services
- qrexec policy files
- Firewall (DPI, IDS)
- DHCP configuration
- DNS Configuration
- VLAN Configuration
- LLM Setup

### 4️⃣ Security & Privacy Considerations
- Audit and harden GPU passthrough access.
- Verify strong isolation between the AI VM and sensitive config VMs.
- (Optional) Move model downloads behind Tor (`sys-whonix`) for better anonymity.
To prevent prompt injection via logs:
	•	Sanitize log inputs
	•	Separate logs from prompts, block prompt injection
	•	Enforce strict templates
	•	Never allow AI or Dev VM direct write access to any config or templates
	•	Log and audit everything


### Configuration & Security Considerations:

- **Secure qrexec Setup:**
  Configure qrexec services in `dom0` to only allow necessary data transfers between VMs.
  Use `ask` or `allow` in policies depending on the desired level of user interaction and security.

- **Isolation and Least Privilege:**
  Minimize the attack surface by ensuring each VM has only the access it needs.
  Continuous monitoring and auditing of qrexec usage can ensure compliance with security policies.

- **Log Handling:**
  Logs and configuration data should only be exposed to necessary VMs with controlled access protocols.
  The architecture promotes strong data governance and confidentiality through secure and explicit inter-VM communication.

## Getting Started
To get started, ensure you have a working knowledge of Linux and Qubes OS fundamentals (Disposable VMs, Templates, etc.). Follow the hardware and virtualization setup steps below to prepare your environment, then proceed with AI environment setup and integration.

## dom0 Responsibilities and qrexec Configuration
The `dom0` domain is the trusted administrative domain in Qubes OS responsible for managing VM lifecycles, enforcing security policies, and configuring inter-VM communication. To enable secure interactions between VMs in this AI router setup, custom **qrexec** services are defined and managed within `dom0`. These services act as controlled interfaces allowing specific commands or data transfers while preventing unauthorized access.
By carefully managing qrexec services in `dom0`, this AI router architecture maintains strong isolation between components while enabling necessary, secure inter-VM communication.
Salt configuration in dom0 maintains VM template configurations 

### Qrexec Rules:

- **Service Configuration Fetching:**
```bash
sys-dev sys-config sys-config.get-dev-config ask
sys-dns sys-config sys-config.get-dns-config ask
sys-dhcp sys-config sys-config.get-dhcp-config ask 
sys-lan sys-config sys-config.get-lan-config ask
```

- **AI Command Execution:**
```bash
  sys-dev sys-ai sys-ai.run-ollama allow
```