# Qubes AI Router

## Getting Started

See [INSTALLATION.md](./docs/INSTALLATION.md) for instructions on bootstrapping your Qubes AI Router.

## Benefits and Philosophy

This project provides a secure, modular, and powerful AI-assisted security router environment built on [Qubes OS](https://www.qubes-os.org/intro/). It combines cutting-edge AI with strong security practices that respect your privacy while delivering robust automation and analysis capabilities.

Key advantages include:

- **Service Separation**: Each core router function (DNS, DHCP, VPN, VLAN, etc.) runs in its own VM. This isolates vulnerabilities in one service from affecting others and reduces the system's overall attack surface.
- **Least Privilege by Design**: Dedicated VMs have only the permissions they need, minimizing the blast radius of any compromise.
- **Privacy-First AI**: All AI inference (anomaly detection, tagging) occurs locally in isolated VMs, with no cloud dependencies.
- **GPU-Accelerated**: PCI passthrough enables hardware acceleration for fast AI inference.
- **Modular Architecture**: Qubes VM separation keeps logs, configurations, and AI components securely isolated.
- **Anomaly Detection**: Continuous log parsing and contextual analysis detect suspicious activity in real time.
- **Self-Sovereign Intelligence**: Your data and insights remain yours—no third-party services or data sharing.
- **Isolated Interactions**: VMs communicate only through controlled interfaces (like Qubes qrexec services and API endpoints), with no direct device or file sharing. This limits lateral movement even if one VM is compromised.
- **Attack Path Mitigation**: Segregating services contains common attack vectors within their respective Qubes, preserving system integrity.
- **Salt Stack**: VM creation, state management ensuring compatibility with Qubes

## VM Architecture Overview

| VM Name     | Purpose                                    
|-------------|--------------------------------------------
| dom0        | Qubes management domain; oversees VM lifecycle, security policies, and system updates
| sys-ai      | Inference engine running Ollama + GPU passthrough (Phi3, Mistral, etc.)
| sys-dev     | Development environment with VS Code, LangChain, scripting tools, API calls to sys-ai
| sys-state   | Centralized storage for all persistent data: DHCP leases, DNS filter lists in a Git-managed repo
| sys-log     | Log ingestion from disposable VMs
| sys-router  | Disposable Gateway VM for traffic routing (DHCP, DNS, VPN, VLANs)
| sys-dns     | Disposable DNS server VM
| sys-dhcp    | Disposable DHCP server VM
| sys-vpn     | Disposable VPN VM (optional)
| sys-vlan    | Disposable NetVM handling VLAN tagging

## State and Log Management

This architecture uses Qubes OS’s isolation model to enforce strict separation between volatile and persistent data, while still enabling automated stateful operation and centralized AI-assisted log analysis.

### 🔐 State Persistence

- **sys-state** acts as the authoritative Git-managed storage VM. It holds:
  - DHCP lease files
  - DNS blocklists

- Disposable service VMs (**sys-dns**, **sys-dhcp**, **sys-router**, etc.) **pull their runtime configuration** from `sys-state` at boot via controlled qrexec calls.
- Updates to state (e.g., a new DHCP lease or modified blocklist) are written back to `sys-state` using secure qrexec write endpoints.
- All state files are versioned using Git to ensure auditability and rollback capability.

### 📦 Log Collection & Routing

- **sys-log** is a dedicated VM that receives logs from all other service VMs via qrexec-based push channels.
- Logs are tagged with VM identifiers and timestamps upon arrival to facilitate later indexing and correlation.

- **sys-dev** acts as a mediator, pulling log data from `sys-log` and pushing it to `sys-ai` for inference. This isolates raw logs from AI analysis for stronger compartmentalization.

- Logs may include:
  - DNS query patterns
  - DHCP assignment history
  - Systemd/journal entries from critical services

### 🧠 Integration with AI Inference


## Inter-VM Connectivity Architecture

This section outlines the architecture for interconnections between VMs and the qrexec services facilitating secure interactions.

- All inter-VM transfers (state, logs, config) use **qrexec services** explicitly defined with minimal privileges.
- `sys-state` and `sys-log` are **persistent, non-networked VMs** to reduce exposure.
- Service VMs are DisposableVMs by default, ensuring clean state and no lingering traces between reboots.

### Key Inter-VM Connections:

1. **DNS and DHCP Services:**
   - **sys-dns** and **sys-dhcp** VMs communicate with **sys-router** for processing DNS queries and assigning IP leases.
   - Dynamic configurations are pulled from **sys-config** using qrexec services to ensure centralized management.

2. **VLAN Tagging:**
   - **sys-vlan** Manages network segmentation .

3. **VPN Configuration:**
   - **sys-vpn** is optionally used for secure external connections.
   - Configurations and keys are securely retrieved from **salt pillar**.

4. **Configuration & Log Management:**
   - **sys-config** serves as the centralized repository for all dynamic files and logs.
   - Configurations are fetched by service VMs on startup using dedicated qrexec services to enforce read-only access.
   - Logs are accessed by the **sys-ai** VM through the **sys-dev** VM, which orchestrates AI prompts and analyzes data using LangChain.

5. **AI Predictions and Inference:**
   - **sys-ai** handles AI inference tasks, using GPU acceleration through PCI passthrough.
   - Commands and data for AI processing are sent from **sys-dev** using qrexec services.
   - `sys-ai` never accesses service VMs directly.
   - Instead, `sys-dev` formulates context-rich queries or summaries and invokes inference using LangChain-style prompts.
   - Resulting insights are returned to `sys-dev` for presentation, rule updates, or alerting.