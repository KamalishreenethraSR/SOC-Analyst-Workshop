#!/usr/bin/env bash
# Network Check Utility for Python Web Application Security + WAF + SOC Lab

set -e

echo "========================================"
echo " NETWORK DISCOVERY & ENVIRONMENT CHECK"
echo "========================================"

# Detect primary IP address
PRIMARY_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
if [ -z "$PRIMARY_IP" ]; then
    PRIMARY_IP="127.0.0.1"
fi

echo "[+] Primary System IP Address : ${PRIMARY_IP}"
echo "[+] Hostname                  : $(hostname)"
echo "[+] Operating System          : $(uname -s) $(uname -r)"

if command -v python3 >/dev/null 2>&1; then
    echo "[+] Python Version            : $(python3 --version)"
else
    echo "[!] Python 3 is NOT installed!"
fi

echo "========================================"
echo "Network configuration check complete."
