#!/bin/bash
# setup.sh - Configure defenses and telemetry for ICMP Flood detection on Ubuntu target.

set -e

echo "[*] Configuring ICMP Flood telemetry..."

# Configure iptables to log and limit incoming ICMP (ping) traffic
echo "[*] Applying UFW logging and iptables logging rule for high rate ICMP packets..."

# Append a rule to log ICMP requests that exceed a normal limit
# This creates a log pattern in /var/log/syslog when ICMP traffic exceeds 5 packets/sec
sudo iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 5/s --limit-burst 10 -j ACCEPT
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j LOG --log-prefix "LIMIT EXCEEDED ICMP: "

echo "[+] Target environment setup complete for ICMP Flood detection."
