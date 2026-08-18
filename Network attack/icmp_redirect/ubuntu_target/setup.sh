#!/bin/bash
# setup.sh - Configure defenses and telemetry for ICMP Redirect attacks on Ubuntu target.

set -e

echo "[*] Configuring ICMP Redirect telemetry..."

# Disable acceptance of ICMP redirects to mitigate route hijacking
# Log attempts via iptables logging
echo "[*] Configuring kernel sysctl parameter to ignore ICMP Redirects..."
sudo sysctl -w net.ipv4.conf.all.accept_redirects=0
sudo sysctl -w net.ipv4.conf.default.accept_redirects=0

# Log incoming ICMP redirects at the firewall level
echo "[*] Adding firewall logging rules for ICMP redirect packets..."
sudo iptables -A INPUT -p icmp --icmp-type redirect -j LOG --log-prefix "ICMP REDIRECT ATTEMPT: "

echo "[+] Target environment setup complete for ICMP Redirect detection."
