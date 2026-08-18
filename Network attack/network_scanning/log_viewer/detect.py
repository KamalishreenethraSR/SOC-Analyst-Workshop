#!/usr/bin/env python3
# detect.py - Network Scanning detector utility for Ubuntu target logs.

import os
import re
import sys
from datetime import datetime

# Paths to potential log files
UFW_LOG = "/var/log/ufw.log"
SYSLOG = "/var/log/syslog"
SURICATA_FAST = "/var/log/suricata/fast.log"

def analyze_ufw_scans():
    print("[*] Analyzing UFW firewall logs for potential port sweeps...")
    log_path = UFW_LOG if os.path.exists(UFW_LOG) else (SYSLOG if os.path.exists(SYSLOG) else None)
    if not log_path:
        print("[-] UFW logs or syslog not found. Ensure UFW logging is enabled.")
        return

    # Pattern to match UFW block events: DST, SRC, SPT, DPT
    # Example: [UFW BLOCK] IN=eth1 OUT= MAC=... SRC=192.168.56.10 DST=192.168.56.20 ... PROTO=TCP SPT=45832 DPT=80
    ufw_pattern = re.compile(
        r"\[UFW BLOCK\].*SRC=(?P<src>[0-9\.]+)\s+DST=(?P<dst>[0-9\.]+).*PROTO=(?P<proto>\w+)\s+SPT=(?P<spt>\d+)\s+DPT=(?P<dpt>\d+)"
    )

    events_by_src = {}
    with open(log_path, "r", errors="ignore") as f:
        for line in f:
            match = ufw_pattern.search(line)
            if match:
                src = match.group("src")
                dpt = match.group("dpt")
                if src not in events_by_src:
                    events_by_src[src] = set()
                events_by_src[src].add(dpt)

    detected = False
    for src, ports in events_by_src.items():
        if len(ports) >= 15:
            print(f"[!] ALERT: Potential Port Scan detected from Host {src}!")
            print(f"    - Blocked unique destination ports: {len(ports)}")
            print(f"    - Target Ports: {sorted(list(ports))[:10]}... (showing first 10)")
            detected = True
            
    if not detected:
        print("[+] No anomalous UFW blocked sweeps detected.")

def analyze_suricata_alerts():
    print("[*] Analyzing Suricata IDS alerts for scanning signatures...")
    if not os.path.exists(SURICATA_FAST):
        print(f"[-] Suricata alert log not found at {SURICATA_FAST}.")
        return

    # Example: 08/18/2026-09:20:00.123456  [**] [1:1000001:1] SCAN TCP port sweep [**] [Classification: ...] [Priority: 3] {TCP} 192.168.56.10:45231 -> 192.168.56.20:80
    scan_pattern = re.compile(r"SCAN\s+(TCP|UDP)\s+port\s+sweep")

    alerts = 0
    with open(SURICATA_FAST, "r", errors="ignore") as f:
        for line in f:
            if scan_pattern.search(line):
                print(f"[!] Suricata Alert: {line.strip()}")
                alerts += 1

    if alerts == 0:
        print("[+] No Suricata port scan alerts found.")
    else:
        print(f"[+] Total Suricata scan alerts: {alerts}")

if __name__ == "__main__":
    print("=== Network Scanning Detection Engine ===")
    analyze_ufw_scans()
    print("-" * 50)
    analyze_suricata_alerts()
