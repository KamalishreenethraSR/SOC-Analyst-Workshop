#!/bin/bash
# setup.sh - Configure auditd to monitor shell executions on the Ubuntu target.

set -e

echo "[*] Configuring Auditd rules for process execution monitoring..."

# Install auditd
if ! command -v auditd &> /dev/null; then
    echo "[*] Installing auditd..."
    sudo apt-get update -y
    sudo apt-get install -y auditd audispd-plugins
fi

# Apply rules to track process invocation (execve system calls)
AUDIT_RULES="/etc/audit/rules.d/audit.rules"

echo "[*] Writing process execution tracking rules..."
sudo tee "$AUDIT_RULES" > /dev/null << 'EOF'
# Remove all existing rules
-D

# Buffer size
-b 8192

# Monitor process execution (execve syscall) for 64-bit binaries
-a always,exit -F arch=b64 -S execve -k process_execution

# Monitor process execution (execve syscall) for 32-bit binaries
-a always,exit -F arch=b32 -S execve -k process_execution

# Monitor system network connection calls
-a always,exit -F arch=b64 -S socket -S connect -k socket_connections
-a always,exit -F arch=b32 -S socket -S connect -k socket_connections
EOF

# Restart auditd service
sudo service auditd restart || sudo systemctl restart auditd

echo "[+] Target environment setup complete for reverse shell monitoring."
