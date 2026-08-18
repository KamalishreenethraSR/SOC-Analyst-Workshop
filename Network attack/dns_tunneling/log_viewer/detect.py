#!/usr/bin/env python3
# detect.py - DNS Tunneling detector utility for Ubuntu target logs.

import os
import re

SURICATA_FAST = "/var/log/suricata/fast.log"

def analyze_dns_tunneling():
    print("[*] Analyzing Suricata alerts for DNS Tunneling signatures...")
    if not os.path.exists(SURICATA_FAST):
        print(f"[-] Suricata alert log not found at {SURICATA_FAST}.")
        return

    # Check for DNS Tunneling custom rules match
    dns_pattern = re.compile(r"DNS Tunneling")

    alerts = 0
    with open(SURICATA_FAST, "r", errors="ignore") as f:
        for line in f:
            if dns_pattern.search(line):
                print(f"[!] IDS ALERT: DNS Tunneling Activity Detected!")
                print(f"    - Event details: {line.strip()}")
                alerts += 1

    if alerts == 0:
        print("[+] No active DNS Tunneling signatures matched in Suricata logs.")
    else:
        print(f"[+] Total DNS Tunnel alerts: {alerts}")

if __name__ == "__main__":
    print("=== DNS Tunneling Detection Engine ===")
    analyze_dns_tunneling()
