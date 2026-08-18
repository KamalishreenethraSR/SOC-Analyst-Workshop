#!/usr/bin/env python3
# detect.py - ARP Spoofing detector utility for Ubuntu target logs.

import os
import re

SYSLOG = "/var/log/syslog"

def analyze_arp_spoofing():
    print("[*] Analyzing syslog for arpwatch ARP spoofing alerts...")
    if not os.path.exists(SYSLOG):
        print(f"[-] Log file {SYSLOG} not found. Ensure arpwatch is running and syslog is populated.")
        return

    # Check for arpwatch events
    # Example: Aug 18 09:20:00 target arpwatch: flip flop 192.168.56.20 00:11:22:33:44:55 (00:aa:bb:cc:dd:ee)
    # Example: Aug 18 09:20:00 target arpwatch: changed ethernet address 192.168.56.1 00:11:22:33:44:55 (00:50:56:c0:00:08)
    arpwatch_pattern = re.compile(
        r"arpwatch:\s+(?P<type>flip flop|changed ethernet address|reassociation)\s+(?P<ip>[0-9\.]+)\s+(?P<mac>[0-9a-fA-F:]+)"
    )

    alerts = 0
    with open(SYSLOG, "r", errors="ignore") as f:
        for line in f:
            match = arpwatch_pattern.search(line)
            if match:
                alert_type = match.group("type").upper()
                ip = match.group("ip")
                mac = match.group("mac")
                print(f"[!] ARPWATCH ALERT: Potential ARP Poisoning Event!")
                print(f"    - Type: {alert_type}")
                print(f"    - Affected IP: {ip}")
                print(f"    - New/Flapping MAC: {mac}")
                print(f"    - Raw Event: {line.strip()}")
                alerts += 1

    if alerts == 0:
        print("[+] No anomalous MAC address reassociations detected in logs.")
    else:
        print(f"[+] Total ARP anomalies detected: {alerts}")

if __name__ == "__main__":
    print("=== ARP Spoofing Detection Engine ===")
    analyze_arp_spoofing()
