#!/bin/bash
# setup.sh - Configure Suricata rules for ICMP Tunneling detection on Ubuntu target.

set -e

echo "[*] Configuring ICMP Tunneling detection telemetry..."

# Install Suricata
if ! command -v suricata &> /dev/null; then
    echo "[*] Installing Suricata..."
    sudo apt-get update -y
    sudo apt-get install -y suricata
fi

# Add rule to detect non-standard ICMP payload sizes and frequencies
# Normal pings carry specific system payloads. Anomaly occurs when payload size is large
# or contains non-ping signature data patterns.
SURICATA_RULES_DIR="/etc/suricata/rules"
sudo mkdir -p "$SURICATA_RULES_DIR"

echo "[*] Adding Suricata rules for ICMP payload inspection..."
cat << 'EOF' | sudo tee "$SURICATA_RULES_DIR/icmp_tunnel.rules" > /dev/null
alert icmp any any -> any any (msg:"ICMP Tunneling - Large Payload Echo Request"; itype:8; dsize:>1000; sid:1000004; rev:1;)
alert icmp any any -> any any (msg:"ICMP Tunneling - Non-standard Echo Payload"; itype:8; content:!"abcdefghijklmnopqrstuvw"; sid:1000005; rev:1;)
EOF

# Ensure rule inclusion in suricata.yaml
if [ -f /etc/suricata/suricata.yaml ]; then
    if ! grep -q "icmp_tunnel.rules" /etc/suricata/suricata.yaml; then
        echo "  - icmp_tunnel.rules" | sudo tee -a /etc/suricata/suricata.yaml > /dev/null
    fi
fi

# Restart Suricata
sudo systemctl restart suricata || true

echo "[+] Target environment setup complete for ICMP Tunneling detection."
