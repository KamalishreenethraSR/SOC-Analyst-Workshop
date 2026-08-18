#!/usr/bin/env python3
# detect.py - UDP Flood detector utility for Ubuntu target logs.

import os
import re
from collections import defaultdict

SYSLOG = "/var/log/syslog"

def analyze_udp_flood():
    print("[*] Analyzing syslog for UDP flood indicators...")
    if not os.path.exists(SYSLOG):
        print(f"[-] Log file {SYSLOG} not found.")
        return

    # Check for iptables logs indicating UDP rate limit exceeded
    # Example: Aug 18 09:20:00 target kernel: LIMIT EXCEEDED UDP: IN=eth1 OUT= MAC=... SRC=192.168.56.10 DST=192.168.56.20 ... PROTO=UDP SPT=56321 DPT=53
    iptables_pattern = re.compile(r"LIMIT EXCEEDED UDP:.*SRC=(?P<src>[0-9\.]+).*DPT=(?P<dpt>\d+)")

    iptables_alerts = defaultdict(int)
    dest_ports = defaultdict(set)

    with open(SYSLOG, "r", errors="ignore") as f:
        for line in f:
            match = iptables_pattern.search(line)
            if match:
                src = match.group("src")
                dpt = match.group("dpt")
                iptables_alerts[src] += 1
                dest_ports[src].add(dpt)

    detected = False
    for src, count in iptables_alerts.items():
        if count > 5:
            print(f"[!] ALERT: Potential UDP Flooding detected from Host {src}!")
            print(f"    - Blocked/Logged UDP packet events: {count}")
            print(f"    - Destination ports affected: {sorted(list(dest_ports[src]))[:5]}... (showing first 5)")
            detected = True

    if not detected:
        print("[+] No active UDP flooding events detected in logs.")

if __name__ == "__main__":
    print("=== UDP Flood Detection Engine ===")
    analyze_udp_flood()
