#!/bin/bash
# setup.sh - Configure defenses and telemetry for ARP Spoofing detection on Ubuntu target.

set -e

echo "[*] Configuring ARP Spoofing telemetry..."

# Install arpwatch
if ! command -v arpwatch &> /dev/null; then
    echo "[*] Installing arpwatch daemon..."
    sudo apt-get update -y
    sudo apt-get install -y arpwatch
fi

# Locate main network interface
DEFAULT_IFACE=$(ip route get 8.8.8.8 2>/dev/null | awk '{print $5}' || echo "eth0")

# Configure arpwatch default interface
if [ -f /etc/default/arpwatch ]; then
    echo "[*] Configuring arpwatch to monitor interface: $DEFAULT_IFACE"
    sudo sed -i "s/ARGS=\"-N\"/ARGS=\"-N -i $DEFAULT_IFACE\"/g" /etc/default/arpwatch
fi

# Enable and start arpwatch service
sudo systemctl enable arpwatch || true
sudo systemctl restart arpwatch || true

echo "[+] Target environment setup complete for ARP Spoofing detection."
