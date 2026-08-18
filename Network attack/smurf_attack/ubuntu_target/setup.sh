#!/bin/bash
# setup.sh - Configure defenses and logging for Smurf Attacks on Ubuntu target.

set -e

echo "[*] Configuring Smurf Attack mitigation and logging..."

# Disable Directed Broadcast acceptance
echo "[*] Configuring kernel parameter to ignore directed broadcasts..."
sudo sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1

# Log packets sent to broadcast addresses
echo "[*] Adding firewall logging rules for potential broadcast sweeps..."
sudo iptables -A INPUT -p icmp -m pkttype --pkt-type broadcast -j LOG --log-prefix "ICMP BROADCAST RECV: "

echo "[+] Target environment setup complete for Smurf Attack detection."
