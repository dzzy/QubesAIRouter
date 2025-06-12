#!/bin/bash
# bootstrap.sh — Master Initial Deployment Script for Qubes AI Router

# Ensures execution stops on errors
set -e

# Source master configuration file
source ./config.sh

# --- Template Creation ---
echo "### Cloning templates..."
SERVICE_VMS=("$DNS_VM" "$DHCP_VM" "$VPN_VM" "$AI_VM" "$LAN_VM" "$ROUTER_VM" "$DEV_VM" "$CONFIG_VM")
for VM in "${SERVICE_VMS[@]}"; do
  qvm-clone "$BASE_TEMPLATE" "${CUSTOM_TEMPLATE_PREFIX}${VM}"
done

# --- VM Creation & NetVM Assignment ---
echo "### Creating VMs and assigning netVMs..."
create_vm_with_netvm() {
    local vm_name=$1
    local template_name=$2
    local label=$3
    local class=$4
    local netvm=$5

    echo "Creating VM $vm_name..."
    qvm-create "$vm_name" --template "$template_name" --label "$label" --class "$class"

    echo "Assigning NetVM ($netvm) to VM $vm_name..."
    qvm-prefs "$vm_name" netvm "$netvm"
}

# VM network setup based on master config file (config.sh)
create_vm_with_netvm "$ROUTER_VM" "${CUSTOM_TEMPLATE_PREFIX}${ROUTER_VM}" "$LABEL_ROUTER" "AppVM" "$UPSTREAM_NETVM"
create_vm_with_netvm "$DNS_VM" "${CUSTOM_TEMPLATE_PREFIX}${DNS_VM}" "$LABEL_SERVICE" "AppVM" "$ROUTER_VM"
create_vm_with_netvm "$DHCP_VM" "${CUSTOM_TEMPLATE_PREFIX}${DHCP_VM}" "$LABEL_SERVICE" "AppVM" "$ROUTER_VM"
create_vm_with_netvm "$VPN_VM" "${CUSTOM_TEMPLATE_PREFIX}${VPN_VM}" "$LABEL_SERVICE" "AppVM" "$ROUTER_VM"
create_vm_with_netvm "$LAN_VM" "${CUSTOM_TEMPLATE_PREFIX}${LAN_VM}" "$LABEL_SERVICE" "AppVM" "$ROUTER_VM"
create_vm_with_netvm "$AI_VM" "${CUSTOM_TEMPLATE_PREFIX}${AI_VM}" "$LABEL_AI" "HVM" "$ROUTER_VM"
create_vm_with_netvm "$DEV_VM" "${CUSTOM_TEMPLATE_PREFIX}${DEV_VM}" "$LABEL_DEV" "AppVM" "$ROUTER_VM"

# No-network Config VM
create_vm_with_netvm "$CONFIG_VM" "${CUSTOM_TEMPLATE_PREFIX}${CONFIG_VM}" "$LABEL_CONFIG" "AppVM" "none"

# --- (Optional) GPU Attach for AI VM ---
echo "### Attaching GPU PCI device to AI VM ($AI_VM)..."
qvm-pci attach "$AI_VM" "dom0:${GPU_PCI_ADDRESS}"

# --- Call additional scripts for finer-grained setups ---
echo "### Calling additional service scripts..."
./scripts/setup_qrexec_services.sh
./scripts/configure_firewall.sh
./scripts/deploy_dhcp_dns.sh
./scripts/setup_llm_env.sh

echo "Bootstrap complete! All VMs and core configurations set."