#!/bin/bash
# setup_all.sh - Master script to install and configure all telemetry defenses on the Ubuntu Target.

set -e

echo "=== Beginning Master Target Telemetry Configuration ==="

# Define all specific attack paths
ATTACKS=(
    "network_scanning"
    "icmp_flood"
    "syn_flood"
    "udp_flood"
    "arp_spoofing"
    "icmp_redirect"
    "ssh_brute_force"
    "ftp_brute_force"
    "metasploit_reverse_shell"
    "ping_of_death"
    "smurf_attack"
    "icmp_tunneling"
    "dns_tunneling"
    "icmp_exfiltration"
)

# Iterate and run setups
for attack in "${ATTACKS[@]}"; do
    setup_script="./${attack}/ubuntu_target/setup.sh"
    if [ -f "$setup_script" ]; then
        echo "--------------------------------------------------"
        echo "[*] Executing: $setup_script"
        chmod +x "$setup_script"
        # Run individual setup
        bash "$setup_script"
    else
        echo "[-] Warning: Setup script not found at $setup_script"
    fi
done

echo "--------------------------------------------------"
echo "[+] Master Target Telemetry Setup completed successfully!"
