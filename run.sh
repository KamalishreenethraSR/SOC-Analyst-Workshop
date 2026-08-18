#!/usr/bin/env bash
# ==============================================================================
# Docker SOC Server Stack - Entry Point Runner Script
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/install-docker-soc-server.sh"

echo "======================================================================"
echo " Starting Docker SOC Server Stack Automated Setup"
echo "======================================================================"

# Automatically escalate privileges using sudo if not already root
if [ "$EUID" -ne 0 ]; then
    echo "Privilege escalation required. Executing installation with sudo..."
    exec sudo "$INSTALL_SCRIPT" "$@"
else
    exec "$INSTALL_SCRIPT" "$@"
fi
