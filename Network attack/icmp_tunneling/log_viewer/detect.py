#!/usr/bin/env python3
# detect.py - ICMP Tunneling detector utility for Ubuntu target logs.

import os
import re

SURICATA_FAST = "/var/log/suricata/fast.log"

def analyze_icmp_tunneling():
    print("[*] Analyzing Suricata alerts for ICMP Tunneling signatures...")
    if not os.path.exists(SURICATA_FAST):
        print(f"[-] Suricata alert log not found at {SURICATA_FAST}.")
        return

    # Check for ICMP Tunneling rules match
    tunnel_pattern = re.compile(r"ICMP Tunneling")

    alerts = 0
    with open(SURICATA_FAST, "r", errors="ignore") as f:
        for line in f:
            if tunnel_pattern.search(line):
                print(f"[!] IDS ALERT: ICMP Tunneling Activity Detected!")
                print(f"    - Event details: {line.strip()}")
                alerts += 1

    if alerts == 0:
        print("[+] No active ICMP Tunneling signatures matched in Suricata logs.")
    else:
        print(f"[+] Total ICMP Tunnel alerts: {alerts}")

if __name__ == "__main__":
    print("=== ICMP Tunneling Detection Engine ===")
    analyze_icmp_tunneling()
