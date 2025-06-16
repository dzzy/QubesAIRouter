# Installation

Save the [Install Script](../scripts/install.sh) as `install.sh` and run from dom0 after making executable with `chmod +x install.sh`

```bash
#!/bin/bash
set -euo pipefail

TEST="true"

cleanup() {
  echo "Cleaning up temporary resources..."
  qvm-kill sys-git 2>/dev/null || true
  qvm-remove -f sys-git 2>/dev/null || true
  rm -f /tmp/salt_bundle.tar.gz
}
trap cleanup EXIT

# 0. Remove existing files
echo "Cleaning previous project files..."
rm -rf /srv/salt/qairouter || true
rm -rf /srv/pillar/qairouter || true

# 1. Create temporary Git VM
echo "Creating sys-git VM..."
qvm-create sys-git --template fedora-41-xfce --label red --property netvm='sys-firewall' || true

# 2. Install git and clone repo
echo "Installing git and cloning repo..."
qvm-run -u root -p sys-git 'dnf install -y git' || echo "Failed to install git"
qvm-run -p sys-git 'git clone https://github.com/dzzy/QubesAIRouter ~/QubesAIRouter' || echo "Failed to clone repo"

# 3. Tar up salt and pillar directories
echo "Archiving salt and pillar directories..."
qvm-run -p sys-git 'tar -czf /home/user/salt_bundle.tar.gz -C /home/user/QubesAIRouter salt pillar' || echo "Failed to create tarball"

# 4. Transfer archive to dom0
echo "Transferring archive to dom0..."
rm -f /tmp/salt_bundle.tar.gz || true
qvm-run --pass-io sys-git 'cat /home/user/salt_bundle.tar.gz' > /tmp/salt_bundle.tar.gz || echo "Failed to copy archive"

# 5. Apply salt states
echo "Applying Salt states..."
if [ "$TEST" = "true" ]; then
  sudo qubesctl state.apply qairouter test=True || echo "Salt test apply failed"
else
  sudo qubesctl state.apply qairouter || echo "Salt apply failed"
fi
```