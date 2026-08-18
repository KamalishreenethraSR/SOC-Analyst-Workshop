#!/bin/bash
# setup.sh - Configure DNS logging and Suricata rules for DNS Tunneling detection on Ubuntu target.

set -e

echo "[*] Configuring DNS Tunneling detection telemetry..."

# Install Suricata
if ! command -v suricata &> /dev/null; then
    echo "[*] Installing Suricata..."
    sudo apt-get update -y
    sudo apt-get install -y suricata
fi

# Add Suricata rule to detect DNS request lengths or query type anomalies
SURICATA_RULES_DIR="/etc/suricata/rules"
sudo mkdir -p "$SURICATA_RULES_DIR"

echo "[*] Adding Suricata rules for DNS inspection..."
# Detect extremely long subdomain requests (typical in DNS tunneling data encoding)
# Detect high frequency TXT record queries (typical in command delivery)
cat << 'EOF' | sudo tee "$SURICATA_RULES_DIR/dns_tunnel.rules" > /dev/null
alert dns any any -> any any (msg:"DNS Tunneling - Long Subdomain Query"; dns.query; content:"."; pcre:"/[a-zA-Z0-9\-]{50,}\./"; sid:1000006; rev:1;)
alert dns any any -> any any (msg:"DNS Tunneling - High TXT Query Volume"; dns.query; threshold: type threshold, track by_src, count 30, seconds 10; sid:1000007; rev:1;)
EOF

# Ensure rule inclusion in suricata.yaml
if [ -f /etc/suricata/suricata.yaml ]; then
    if ! grep -q "dns_tunnel.rules" /etc/suricata/suricata.yaml; then
        echo "  - dns_tunnel.rules" | sudo tee -a /etc/suricata/suricata.yaml > /dev/null
    fi
fi

# Restart Suricata
sudo systemctl restart suricata || true

echo "[+] Target environment setup complete for DNS Tunneling detection."
