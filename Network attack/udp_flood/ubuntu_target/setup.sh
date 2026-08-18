#!/bin/bash
# setup.sh - Configure defenses and telemetry for UDP Flood detection on Ubuntu target.

set -e

echo "[*] Configuring UDP Flood telemetry..."

# Apply iptables logging for high volume UDP traffic
echo "[*] Appending iptables rate limits on UDP requests..."
sudo iptables -A INPUT -p udp -m limit --limit 10/s --limit-burst 20 -j ACCEPT
sudo iptables -A INPUT -p udp -j LOG --log-prefix "LIMIT EXCEEDED UDP: "

echo "[+] Target environment setup complete for UDP Flood detection."
