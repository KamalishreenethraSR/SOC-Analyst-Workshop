#!/usr/bin/env python3
# detect.py - Smurf Attack detector utility for Ubuntu target logs.

import os
import re
from collections import defaultdict

SYSLOG = "/var/log/syslog"

def analyze_smurf_attack():
    print("[*] Analyzing syslog for Smurf Attack indicators...")
    if not os.path.exists(SYSLOG):
        print(f"[-] Log file {SYSLOG} not found. Run target setup first.")
        return

    # Match broadcast receipt warnings
    # Example: Aug 18 09:20:00 target kernel: ICMP BROADCAST RECV: IN=eth1 OUT= MAC=... SRC=192.168.56.10 DST=192.168.56.255 ... PROTO=ICMP TYPE=8 CODE=0
    broadcast_pattern = re.compile(
        r"ICMP BROADCAST RECV:.*SRC=(?P<src>[0-9\.]+)\s+DST=(?P<dst>[0-9\.]+)"
    )

    alert_count = defaultdict(int)

    with open(SYSLOG, "r", errors="ignore") as f:
        for line in f:
            match = broadcast_pattern.search(line)
            if match:
                src = match.group("src")
                alert_count[src] += 1

    detected = False
    for src, count in alert_count.items():
        if count > 5:
            print(f"[!] ALERT: High Broadcast ICMP activity detected (Potential Smurf Sweep)!")
            print(f"    - Packets sent to broadcast by Host {src}: {count}")
            detected = True

    if not detected:
        print("[+] No anomalous ICMP broadcast events detected.")

if __name__ == "__main__":
    print("=== Smurf Attack Detection Engine ===")
    analyze_smurf_attack()
