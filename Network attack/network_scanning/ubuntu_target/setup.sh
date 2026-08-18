#!/bin/bash
# setup.sh - Configure defenses and telemetry for Network Scanning detection on Ubuntu target.

set -e

echo "[*] Configuring Network Scanning telemetry..."

# Install Suricata for IDS rules
if ! command -v suricata &> /dev/null; then
    echo "[*] Installing Suricata..."
    sudo apt-get update -y
    sudo apt-get install -y suricata
fi

# Enable UFW logging (port scan tracking via firewall logs)
echo "[*] Enabling UFW and logging level to HIGH..."
sudo ufw logging high
sudo ufw --force enable

# Custom Suricata Rule for Nmap/Port Scanning
SURICATA_RULES_DIR="/etc/suricata/rules"
sudo mkdir -p "$SURICATA_RULES_DIR"

echo "[*] Adding Suricata rules for Reconnaissance detection..."
cat << 'EOF' | sudo tee "$SURICATA_RULES_DIR/recon.rules" > /dev/null
alert tcp any any -> any any (msg:"SCAN TCP port sweep"; flags:S; threshold: type threshold, track by_src, count 20, seconds 10; sid:1000001; rev:1;)
alert udp any any -> any any (msg:"SCAN UDP port sweep"; threshold: type threshold, track by_src, count 20, seconds 10; sid:1000002; rev:1;)
EOF

# Ensure rule inclusion in suricata.yaml
if [ -f /etc/suricata/suricata.yaml ]; then
    if ! grep -q "recon.rules" /etc/suricata/suricata.yaml; then
        echo "  - recon.rules" | sudo tee -a /etc/suricata/suricata.yaml > /dev/null
    fi
fi

# Restart services
sudo systemctl restart suricata || true
echo "[+] Target environment setup complete for Network Scanning detection."
