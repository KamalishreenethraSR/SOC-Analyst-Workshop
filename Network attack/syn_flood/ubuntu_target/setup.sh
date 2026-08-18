#!/bin/bash
# setup.sh - Configure defenses and telemetry for TCP SYN Flood detection on Ubuntu target.

set -e

echo "[*] Configuring TCP SYN Flood telemetry..."

# Enable SYN Cookies defense and log alerts to syslog
echo "[*] Enabling SYN Cookies defense in sysctl..."
sudo sysctl -w net.ipv4.tcp_syncookies=1

# Apply iptables logging for high volumes of SYN requests
echo "[*] Appending iptables rate limits on TCP SYN requests..."
sudo iptables -A INPUT -p tcp --syn -m limit --limit 10/s --limit-burst 20 -j ACCEPT
sudo iptables -A INPUT -p tcp --syn -j LOG --log-prefix "LIMIT EXCEEDED TCP SYN: "

echo "[+] Target environment setup complete for TCP SYN Flood detection."
