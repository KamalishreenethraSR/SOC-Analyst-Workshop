#!/bin/bash
# setup.sh - Configure Suricata for Ping of Death detection on Ubuntu target.

set -e

echo "[*] Configuring Ping of Death telemetry..."

# Install Suricata
if ! command -v suricata &> /dev/null; then
    echo "[*] Installing Suricata..."
    sudo apt-get update -y
    sudo apt-get install -y suricata
fi

# Add rule to detect oversized ICMP packets (Ping of Death)
SURICATA_RULES_DIR="/etc/suricata/rules"
sudo mkdir -p "$SURICATA_RULES_DIR"

echo "[*] Writing custom Suricata rules for oversized ICMP packets..."
# IPv4 packets total size limit is 65535 bytes. Oversized payloads triggers alerts.
cat << 'EOF' | sudo tee "$SURICATA_RULES_DIR/ping_death.rules" > /dev/null
alert icmp any any -> any any (msg:"ICMP Large Packet - Possible Ping of Death"; dsize:>60000; sid:1000003; rev:1;)
EOF

# Ensure rule inclusion in suricata.yaml
if [ -f /etc/suricata/suricata.yaml ]; then
    if ! grep -q "ping_death.rules" /etc/suricata/suricata.yaml; then
        echo "  - ping_death.rules" | sudo tee -a /etc/suricata/suricata.yaml > /dev/null
    fi
fi

# Restart Suricata
sudo systemctl restart suricata || true

echo "[+] Target environment setup complete for Ping of Death detection."
