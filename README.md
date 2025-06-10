# Qubes AI Router Project

## 🌟 Benefits and Philosophy

This project aims to provide a secure, modular, and powerful AI-assisted security router environment built on Qubes OS, blending cutting-edge AI with strong security practices that respect your privacy while delivering powerful automation and analysis capabilities. 

Here’s why it’s awesome:

- **Service Separation**: Each core router function (DNS, DHCP, VPN, VLAN, etc.) is assigned to its own VM. This isolates vulnerabilities in one service from affecting others and reduces the exploitability of the system.
- **Least Privilege by Design**: By splitting services into dedicated VMs, each has only the permissions it needs, which reduces the blast radius of any compromise.
- **Privacy-First AI**: All AI inference happens locally in isolated VMs, no cloud dependencies.
- **GPU-Accelerated**: Using PCI passthrough for hardware acceleration ensures fast inference.
- **Modular Architecture**: The Qubes VM separation ensures that logs, configurations, and AI components stay securely isolated, reducing attack surface.
- **Anomaly Detection**: Continuous log parsing and contextual analysis can detect suspicious activity in real time.
- **Self-Sovereign Intelligence**: Your data and insights remain yours—no third-party services or data sharing.
- **Isolated Interactions**: These separate VMs communicate only through controlled interfaces (like Qubes qrexec services and API endpoints). There is no direct device or file sharing, which limits lateral movement even if one VM is compromised.
- **Attack Path Mitigation**: By segregating services, common attack vectors (like DHCP spoofing, DNS poisoning, VPN tunnel compromise) are contained within their respective VMs. An attacker compromising the DNS VM cannot easily pivot to the DHCP VM or to the AI VM, preserving system integrity.

## Prerequisites
- You should have a working understanding of Linux and the specific enhancements by the Qubes OS project (Disposable VMs, Templates, etc) 

# Configuration Overview

### 🛠️ Hardware and Virtualization Setup
- Use an NVIDIA 30xx+ GPU for best compatibility with CUDA 12
- Pass through GPU (and audio controller) to a dedicated HVM-based `sys-ai` VM.
- Disable dynamic memory balancing in Qubes VM settings.
- Enable strict PCI reset in Qubes global settings to ensure safe GPU resets.
- Disable `nouveau` driver by:
  - Blacklisting it in `/etc/default/grub` config. Add this the GRUB_CMDLINE_LINUX line, `rd.driver.blacklist=nouveau modprobe.blacklist=nouveau`
  - Regenerate GRUB config: `sudo grub2-mkconfig -o /boot/grub2/grub.cfg`
  - Confirm nouveau is not loaded. This should return nothing from a dom0 terminal: `lsmod | grep nouveau`
- Install NVIDIA CUDA drivers `https://developer.nvidia.com/cuda-downloads`
  - Reboot and confirm `nvidia` drivers are in use inside `sys-ai` (`nvidia-smi`, `lsmod`, `lspci`)
  - Install nvidia-smi (`sudo dnf install -y nvidia-smi`)

### 🧰 AI Environment Setup
- Download and install [Ollama](https://ollama.ai)
- Confirm Nvidia driver installation (`nvidia-smi` shows GPU)
- [ ] Install Ollama in the `sys-ai` VM, including:
  - Fetch a suitable LLM for your GPU size (e.g., `llama3` or `mixtral`).
- [ ] Set up a Python environment for LLM orchestration:
  - Install Python 3 (if not already available).
  - Create a virtual environment for package management:
    ```bash
    python3 -m venv ai-env
    source ai-env/bin/activate
    ```
- [ ] Install **LangChain** for structured prompt interactions:
  ```bash
  pip install langchain
  ```
- [ ] Optionally install additional LLM frameworks:
  - [ ] NVIDIA’s TensorRT-LLM toolkit.
  - [ ] [lmdeploy](https://github.com/InternLM/lmdeploy) for efficient serving.
- [ ] Run a test query to verify everything is working:
  ```bash
  ollama run llama3 "Hello AI Router!"
  ```
- [ ] (Optional) Build any custom scripts or services to tie everything together.
- [ ] (Optional) Integrate LLM APIs locally with your IDE (in `sys-router` or other VMs):
  - Example: Connect VS Code or another IDE to the LLM’s API endpoint via a local plugin or custom extension.
  - Example Python integration:
    ```python
    from langchain_community.llms import Ollama

    llm = Ollama(model="llama3", base_url="http://sys-ai:11434")
    prompt = "Parse this YAML config and summarize it."
    response = llm(prompt)
    print(response)
    ```

### 2️⃣ Enable AI Router Capabilities
- [ ] Connect the AI VM (`sys-ai`) to the core Qubes router VM (`sys-router` or equivalent).
- [ ] Set up log file sharing or API endpoints for logs from:
  - Network devices.
  - Qubes firewall VM.
  - Config backups.

### 3️⃣ Integrate MCP Tools and Automation
- [ ] Determine the model size and context size needed for your AI workflows.
- [ ] Use MCP tools (Model Context Protocol) to:
  - Expose logs and config files as structured input.
  - Parse and store historical context.
- [ ] Automate prompt-based analysis and anomaly detection.
- [ ] Possibly deploy:
  - [ ] A vector database (like Qdrant or Weaviate) for historical log embeddings.

### 4️⃣ Security & Privacy Considerations
- [ ] Audit and harden GPU passthrough access.
- [ ] Implement strong isolation between the AI VM and sensitive config VMs.
- [ ] (Optional) Move model downloads behind Tor (`sys-whonix`) for better anonymity.

### 🗂️ Config VM and Git Repository
- Create a dedicated Qubes VM (`sys-config` or similar) for managing configurations and historical data.
- Initialize a Git repository in this VM for tracking configuration changes:
  ```bash
  git init --initial-branch=main
  git add .
  git commit -m "Initial commit"
  ```
- Regularly push changes to an external Git server (or use local-only snapshots if privacy is critical).
- This Git repository can store YAML config files, firewall rules, AI prompt logs, and other operational data.
- Carefully manage the permissions of this VM, as it contains sensitive data.

---

## 🧩 Possible Tooling Choices

- **LLM backend**: Ollama, LMDeploy, vLLM.
- **Prompt engineering / orchestration**: LangChain, LlamaIndex.
- **Vector DB**: Qdrant, Milvus.
- **Anomaly detection**: Use model context + external rules.