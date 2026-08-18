#!/usr/bin/env python3
# detect.py - ICMP Flood detector utility for Ubuntu target logs.

import os
import re
from collections import defaultdict
from datetime import datetime

SYSLOG = "/var/log/syslog"

def analyze_icmp_flood():
    print("[*] Analyzing syslog for ICMP flood signatures...")
    if not os.path.exists(SYSLOG):
        print(f"[-] Log file {SYSLOG} not found. Run target setup first.")
        return

    # Check for iptables limit exceeded warnings
    # Example: Aug 18 09:20:00 target kernel: [ 123.456] LIMIT EXCEEDED ICMP: IN=eth1 OUT= MAC=... SRC=192.168.56.10 DST=192.168.56.20 ... PROTO=ICMP TYPE=8 CODE=0
    limit_pattern = re.compile(r"LIMIT EXCEEDED ICMP:.*SRC=(?P<src>[0-9\.]+)")

    incident_count = defaultdict(int)
    
    with open(SYSLOG, "r", errors="ignore") as f:
        for line in f:
            match = limit_pattern.search(line)
            if match:
                src = match.group("src")
                incident_count[src] += 1

    detected = False
    for src, count in incident_count.items():
        if count > 5:
            print(f"[!] ALERT: ICMP Flooding detected from Host {src}!")
            print(f"    - Blocked/Logged high-rate ICMP packet events: {count}")
            detected = True

    if not detected:
        print("[+] No anomalous ICMP flooding events detected.")

if __name__ == "__main__":
    print("=== ICMP Flood Detection Engine ===")
    analyze_icmp_flood()
