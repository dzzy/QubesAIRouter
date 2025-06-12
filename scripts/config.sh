
# Base VM Templates
BASE_TEMPLATE="fedora-37-minimal"
CUSTOM_TEMPLATE_PREFIX="custom-"

# Qubes Networking VM Names
UPSTREAM_NETVM="sys-net"
ROUTER_VM="sys-router"
AI_VM="sys-ai"
DEV_VM="sys-dev"
CONFIG_VM="sys-config"
DNS_VM="sys-dns"
DHCP_VM="sys-dhcp"
VPN_VM="sys-vpn"
LAN_VM="sys-lan"

# VM Labels (Qubes OS colors)
LABEL_ROUTER="blue"
LABEL_AI="red"
LABEL_DEV="yellow"
LABEL_CONFIG="gray"
LABEL_SERVICE="blue"

# VLAN and Networking Configuration
NUM_VLANS=10
VLAN_IDS=(10 20 30 40 50 60 70 80 90 100)
VLAN_SUBNETS=(
  "192.168.10.0/24"
  "192.168.20.0/24"
  "192.168.30.0/24"
  "192.168.40.0/24"
  "192.168.50.0/24"
  "192.168.60.0/24"
  "192.168.70.0/24"
  "192.168.80.0/24"
  "192.168.90.0/24"
  "192.168.100.0/24"
)
DHCP_RANGES=(
  "192.168.10.50,192.168.10.100"
  "192.168.20.50,192.168.20.100"
  "192.168.30.50,192.168.30.100"
  "192.168.40.50,192.168.40.100"
  "192.168.50.50,192.168.50.100"
  "192.168.60.50,192.168.60.100"
  "192.168.70.50,192.168.70.100"
  "192.168.80.50,192.168.80.100"
  "192.168.90.50,192.168.90.100"
  "192.168.100.50,192.168.100.100"
)

# DNS Configuration
DNS_FORWARDERS=("1.1.1.1" "8.8.8.8")

# AI Model Configurations
LLM_MODEL="llama3"
OLLAMA_PORT=11434

# GPU PCI Passthrough
GPU_PCI_ADDRESS="10:00.0"

# Firewall related settings
ALLOW_EXTERNAL_SSH=false
SSH_ALLOWED_IPS=("")

#Logging and assets
ASSET_FILE="./assets.lst"