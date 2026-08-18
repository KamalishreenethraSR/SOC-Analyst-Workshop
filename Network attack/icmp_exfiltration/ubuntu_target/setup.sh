#!/bin/bash
# setup.sh - Configure Suricata rules for ICMP Exfiltration detection on Ubuntu target.

set -e

echo "[*] Configuring ICMP Exfiltration detection telemetry..."

# Install Suricata
if ! command -v suricata &> /dev/null; then
    echo "[*] Installing Suricata..."
    sudo apt-get update -y
    sudo apt-get install -y suricata
fi

# Add rule to detect non-standard ICMP payload content signatures
SURICATA_RULES_DIR="/etc/suricata/rules"
sudo mkdir -p "$SURICATA_RULES_DIR"

echo "[*] Adding Suricata rules for ICMP exfiltration detection..."
# Detect if packet contains indicators of binary/sensitive headers (e.g. PK zip signatures, database patterns) in ICMP
cat << 'EOF' | sudo tee "$SURICATA_RULES_DIR/icmp_exfil.rules" > /dev/null
alert icmp any any -> any any (msg:"ICMP Exfiltration - Encapsulated ZIP File Header"; itype:8; content:"|50 4b 03 04|"; sid:1000008; rev:1;)
alert icmp any any -> any any (msg:"ICMP Exfiltration - Encapsulated ELF Header"; itype:8; content:"|7f 45 4c 46|"; sid:1000009; rev:1;)
EOF

# Ensure rule inclusion in suricata.yaml
if [ -f /etc/suricata/suricata.yaml ]; then
    if ! grep -q "icmp_exfil.rules" /etc/suricata/suricata.yaml; then
        echo "  - icmp_exfil.rules" | sudo tee -a /etc/suricata/suricata.yaml > /dev/null
    fi
fi

# Restart Suricata
sudo systemctl restart suricata || true

echo "[+] Target environment setup complete for ICMP Exfiltration detection."
