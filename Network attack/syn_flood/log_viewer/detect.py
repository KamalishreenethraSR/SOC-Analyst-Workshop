#!/usr/bin/env python3
# detect.py - TCP SYN Flood detector utility for Ubuntu target logs.

import os
import re
from collections import defaultdict

SYSLOG = "/var/log/syslog"

def analyze_syn_flood():
    print("[*] Analyzing syslog for TCP SYN flood indicators...")
    if not os.path.exists(SYSLOG):
        print(f"[-] Log file {SYSLOG} not found.")
        return

    # Check for kernel messages about SYN flooding
    # Example: TCP: Possible SYN flooding on port 80. Sending cookies. Check System logs.
    kernel_pattern = re.compile(r"Possible SYN flooding on port (?P<port>\d+)")
    
    # Check for iptables log limits
    iptables_pattern = re.compile(r"LIMIT EXCEEDED TCP SYN:.*SRC=(?P<src>[0-9\.]+).*DPT=(?P<dpt>\d+)")

    kernel_alerts = 0
    iptables_alerts = defaultdict(int)

    with open(SYSLOG, "r", errors="ignore") as f:
        for line in f:
            k_match = kernel_pattern.search(line)
            if k_match:
                port = k_match.group("port")
                print(f"[!] KERNEL ALERT: Active SYN Flood Mitigation triggered on port {port}!")
                kernel_alerts += 1
            
            ip_match = iptables_pattern.search(line)
            if ip_match:
                src = ip_match.group("src")
                iptables_alerts[src] += 1

    detected = (kernel_alerts > 0)
    for src, count in iptables_alerts.items():
        if count > 5:
            print(f"[!] FIREWALL ALERT: High SYN rate logged from Host {src}!")
            print(f"    - Blocked/Logged TCP SYN packet events: {count}")
            detected = True

    if not detected:
        print("[+] No active TCP SYN flooding events detected in logs.")

if __name__ == "__main__":
    print("=== TCP SYN Flood Detection Engine ===")
    analyze_syn_flood()
