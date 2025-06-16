# Qubes AI Router

## 🌟 Benefits and Philosophy

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

## 🏗️ VM Architecture Overview

| VM Name     | Purpose                                    
|-------------|--------------------------------------------
| dom0        | Qubes management domain; oversees VM lifecycle, security policies, and system updates
| sys-ai      | Inference engine running Ollama + GPU passthrough (Phi3, Mistral, etc.)
| sys-dev     | Development environment with VS Code, LangChain, scripting tools, API calls to sys-ai
| sys-state   | Centralized storage for all persistent data: DHCP leases, DNS filter lists, etc. in a Git-managed repo
| sys-router  | Disposable Gateway VM for traffic routing (DHCP, DNS, VPN, VLANs)
| sys-dns     | Disposable DNS server VM
| sys-dhcp    | Disposable DHCP server VM
| sys-vpn     | Disposable VPN VM (optional)
| sys-vlan    | Disposable NetVM handling VLAN tagging

On startup, service VMs pull their state data from sys-state
sys-dev pushes logs from sys-state to sys-ai for analysis.

## 🔗 Inter-VM Connectivity Architecture

This section outlines the architecture for interconnections between VMs and the qrexec services facilitating secure interactions.

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