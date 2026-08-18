#!/usr/bin/env python3
# detect.py - Ping of Death detector utility for Ubuntu target logs.

import os
import re

SURICATA_FAST = "/var/log/suricata/fast.log"
SYSLOG = "/var/log/syslog"

def analyze_ping_of_death():
    print("[*] Analyzing Suricata alerts for Ping of Death...")
    if not os.path.exists(SURICATA_FAST):
        print(f"[-] Suricata alert log not found at {SURICATA_FAST}.")
        return

    # Check for PoD custom rules match
    pod_pattern = re.compile(r"Possible Ping of Death")

    alerts = 0
    with open(SURICATA_FAST, "r", errors="ignore") as f:
        for line in f:
            if pod_pattern.search(line):
                print(f"[!] IDS ALERT: Oversized ICMP Packet (Ping of Death) Triggered!")
                print(f"    - Event details: {line.strip()}")
                alerts += 1

    if alerts == 0:
        print("[+] No active Ping of Death signatures matched in Suricata logs.")
    else:
        print(f"[+] Total PoD alerts: {alerts}")

if __name__ == "__main__":
    print("=== Ping of Death Detection Engine ===")
    analyze_ping_of_death()
