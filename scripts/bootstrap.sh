#!/bin/bash
# bootstrap.sh



#End of Variables

#Begin Bootstrap

# Backup existing asset file (if exists)
if [[ -f "$ASSET_FILE" ]]; then
    mv "$ASSET_FILE" "${ASSET_FILE}.$(date +%Y%m%d%H%M%S).bak"
fi

# Clone VM Templates
echo "# VM Templates" > $ASSET_FILE
SERVICE_VMS=("$DNS_VM" "$DHCP_VM" "$VPN_VM" "$AI_VM" "$LAN_VM" "$ROUTER_VM" "$DEV_VM" "$CONFIG_VM")
for VM in "${SERVICE_VMS[@]}"; do
  TEMPLATE_NAME="${CUSTOM_TEMPLATE_PREFIX}${VM}"
  qvm-clone "$BASE_TEMPLATE" "$TEMPLATE_NAME"
  echo "$TEMPLATE_NAME" >> $ASSET_FILE
done

# Create AppVMs
echo -e "\n# AppVMs" >> $ASSET_FILE
create_vm_with_netvm() {
    local vm_name=$1
    local template_name=$2
    local label=$3
    local class=$4
    local netvm=$5

    qvm-create "$vm_name" --template "$template_name" --label "$label" --class "$class"
    qvm-prefs "$vm_name" netvm "$netvm"

    echo "$vm_name" >> $ASSET_FILE
}

# Example VM creation with logging:
create_vm_with_netvm "$ROUTER_VM" "${CUSTOM_TEMPLATE_PREFIX}${ROUTER_VM}" "$LABEL_ROUTER" "AppVM" "$UPSTREAM_NETVM"
create_vm_with_netvm "$DNS_VM" "${CUSTOM_TEMPLATE_PREFIX}${DNS_VM}" "$LABEL_SERVICE" "AppVM" "$ROUTER_VM"
create_vm_with_netvm "$DHCP_VM" "${CUSTOM_TEMPLATE_PREFIX}${DHCP_VM}" "$LABEL_SERVICE" "AppVM" "$ROUTER_VM"
create_vm_with_netvm "$VPN_VM" "${CUSTOM_TEMPLATE_PREFIX}${VPN_VM}" "$LABEL_SERVICE" "AppVM" "$ROUTER_VM"
create_vm_with_netvm "$LAN_VM" "${CUSTOM_TEMPLATE_PREFIX}${LAN_VM}" "$LABEL_SERVICE" "AppVM" "$ROUTER_VM"
create_vm_with_netvm "$AI_VM" "${CUSTOM_TEMPLATE_PREFIX}${AI_VM}" "$LABEL_AI" "HVM" "$ROUTER_VM"
create_vm_with_netvm "$DEV_VM" "${CUSTOM_TEMPLATE_PREFIX}${DEV_VM}" "$LABEL_DEV" "AppVM" "$ROUTER_VM"
create_vm_with_netvm "$CONFIG_VM" "${CUSTOM_TEMPLATE_PREFIX}${CONFIG_VM}" "$LABEL_CONFIG" "AppVM" "none"

# PCI attachments, qrexec, firewall setup as before.

echo "Bootstrap complete; assets saved to $ASSET_FILE"