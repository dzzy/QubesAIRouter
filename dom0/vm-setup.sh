#!/bin/bash

# Define the base template and new custom template names
BASE_TEMPLATE="fedora-37-minimal"
CUSTOM_TEMPLATE_PREFIX="custom-"

# Function to clone a template
clone_template() {
    local original_template=$1
    local new_template=$2

    echo "Cloning template $original_template to $new_template..."
    qvm-clone "$original_template" "$new_template"
}

# Function to create a VM
create_vm() {
    local vm_name=$1
    local template_name=$2
    local label=$3
    local class=$4

    echo "Creating VM $vm_name with template $template_name..."
    qvm-create "$vm_name" --template "$template_name" --label "$label" --class "$class"
}

# Clone the minimal template for each service
clone_template "$BASE_TEMPLATE" "${CUSTOM_TEMPLATE_PREFIX}sys-dns"
clone_template "$BASE_TEMPLATE" "${CUSTOM_TEMPLATE_PREFIX}sys-dhcp"
clone_template "$BASE_TEMPLATE" "${CUSTOM_TEMPLATE_PREFIX}sys-vpn"
clone_template "$BASE_TEMPLATE" "${CUSTOM_TEMPLATE_PREFIX}sys-ai"
clone_template "$BASE_TEMPLATE" "${CUSTOM_TEMPLATE_PREFIX}sys-lan"
clone_template "$BASE_TEMPLATE" "${CUSTOM_TEMPLATE_PREFIX}sys-router"

# Create VMs from the cloned templates
create_vm "sys-dns" "${CUSTOM_TEMPLATE_PREFIX}sys-dns" "blue" "AppVM"
create_vm "sys-dhcp" "${CUSTOM_TEMPLATE_PREFIX}sys-dhcp" "blue" "AppVM"
create_vm "sys-vpn" "${CUSTOM_TEMPLATE_PREFIX}sys-vpn" "blue" "AppVM"
create_vm "sys-ai" "${CUSTOM_TEMPLATE_PREFIX}sys-ai" "red" "HVM"
create_vm "sys-lan" "${CUSTOM_TEMPLATE_PREFIX}sys-lan" "blue" "AppVM"
create_vm "sys-router" "${CUSTOM_TEMPLATE_PREFIX}sys-router" "blue" "AppVM"

# Add any additional configuration here, such as setting preferences or attaching devices
echo "All VMs have been created successfully."