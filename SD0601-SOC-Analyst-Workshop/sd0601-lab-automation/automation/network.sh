#!/usr/bin/env bash
# network.sh — Sets up soc-lab Docker bridge network and network isolation

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"

log_header "NETWORK ISOLATION & BRIDGE SETUP"

NET_NAME="soc-lab"
SUBNET="10.60.0.0/24"
GATEWAY="10.60.0.1"

if docker network inspect "$NET_NAME" &>/dev/null; then
    log_ok "Docker network '$NET_NAME' already exists."
else
    log_info "Creating Docker bridge network '$NET_NAME' ($SUBNET)..."
    docker network create \
        --driver bridge \
        --subnet "$SUBNET" \
        --gateway "$GATEWAY" \
        --opt "com.docker.network.bridge.name"="br-soc-lab" \
        "$NET_NAME"
    log_ok "Network '$NET_NAME' created."
fi
