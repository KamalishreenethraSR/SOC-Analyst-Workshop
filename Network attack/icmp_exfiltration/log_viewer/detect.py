#!/usr/bin/env python3
# detect.py - ICMP Exfiltration detector utility for Ubuntu target logs.

import os
import re

SURICATA_FAST = "/var/log/suricata/fast.log"

def analyze_icmp_exfil():
    print("[*] Analyzing Suricata alerts for ICMP Exfiltration signatures...")
    if not os.path.exists(SURICATA_FAST):
        print(f"[-] Suricata alert log not found at {SURICATA_FAST}.")
        return

    # Check for ICMP Exfiltration custom rules match
    exfil_pattern = re.compile(r"ICMP Exfiltration")

    alerts = 0
    with open(SURICATA_FAST, "r", errors="ignore") as f:
        for line in f:
            if exfil_pattern.search(line):
                print(f"[!] IDS ALERT: ICMP Data Exfiltration Activity Detected!")
                print(f"    - Event details: {line.strip()}")
                alerts += 1

    if alerts == 0:
        print("[+] No active ICMP Exfiltration signatures matched in Suricata logs.")
    else:
        print(f"[+] Total ICMP Exfil alerts: {alerts}")

if __name__ == "__main__":
    print("=== ICMP Exfiltration Detection Engine ===")
    analyze_icmp_exfil()
