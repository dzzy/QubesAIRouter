## 🔧 Installation Guide

The following steps will bootstrap and configure the entire Qubes AI Router environment automatically. This script should be executed in the Qubes OS `dom0` administrative VM.

### Step-by-Step Setup:

- **Always review your `config.sh` carefully before execution.**
- **Keep logs (`bootstrap.log` and `teardown.log`) saved for debugging purposes.**
- **Backup important data and configurations prior to execution of teardown.**

1. **Clone the Repository (In a disposable VM or management VM)**  

   First, clone the repository and copy bootstrap scripts into your dom0 securely:
    ```bash
    git clone <your_repo_url>
    cd QubesAIRouter

    # Copy project to dom0 (run in your management VM)
    qvm-copy-to-vm dom0 ~/QubesAIRouter
    ```

    Move it to a convenient location in dom0:
    ```bash
    # Now in dom0 terminal:
    mv ~/QubesIncoming/<source_vm>/QubesAIRouter ~/QubesAIRouter
    cd ~/QubesAIRouter

    chmod +x bootstrap.sh teardown.sh
    ```
  
2. **Review Configuration (Recommended)**  

   Take a moment to review `config.sh` to verify your setup parameters, such as template names, VM labels, NetVMs, and VLAN/subnet details:
    ```bash
    vim config.sh
    ```

3. **Run the Bootstrap Script**

   Execute the bootstrap script. Recommended to use `tee` to log the output:

    ```bash
    ./bootstrap.sh | tee bootstrap.log
    ```

   This will perform the following actions:
   - Clone Templates
   - Create and configure all custom VMs
   - Configure NetVM assignments, GPU passthrough, and networking configurations
   - Set up qrexec policies, DHCP, DNS, firewall, and AI inference environments
   - Generate an asset registry (`assets.lst`) for easy teardown if necessary  

   **Note:** The execution may take a few minutes, depending on your system and network speed.

4. **Verify Installation**  
   
   Upon successful execution, you should see confirmation messages. Use the Qubes VM Manager to verify newly created VMs and their configurations.


## ♻️ Reverting / Removing the Setup

To fully remove all automatically created VMs and templates, simply run the teardown script provided:

1. **Execute Teardown** in dom0:
   ```bash
   ./teardown.sh | tee teardown.log
   ```
   **Important:** The teardown process permanently deletes the VMs/templates listed in the `assets.lst` file generated during bootstrap. Ensure this is your intent before running. It's always recommended to backup essential data first.

```bash
./bootstrap.sh | tee bootstrap.log
```

### 📓 Final Best Practice Recommendations:
