#!/usr/bin/env python3
# detect.py - ICMP Redirect detector utility for Ubuntu target logs.

import os
import re

SYSLOG = "/var/log/syslog"

def analyze_icmp_redirects():
    print("[*] Analyzing syslog for ICMP Redirect attempts...")
    if not os.path.exists(SYSLOG):
        print(f"[-] Log file {SYSLOG} not found.")
        return

    # Check for firewall logs matching ICMP Redirect rule
    # Example: Aug 18 09:20:00 target kernel: ICMP REDIRECT ATTEMPT: IN=eth1 OUT= MAC=... SRC=192.168.56.10 DST=192.168.56.20 ... PROTO=ICMP TYPE=5 CODE=1
    redirect_pattern = re.compile(
        r"ICMP REDIRECT ATTEMPT:.*SRC=(?P<src>[0-9\.]+)\s+DST=(?P<dst>[0-9\.]+)"
    )

    alerts = 0
    with open(SYSLOG, "r", errors="ignore") as f:
        for line in f:
            match = redirect_pattern.search(line)
            if match:
                src = match.group("src")
                dst = match.group("dst")
                print(f"[!] FIREWALL ALERT: Blocked/Logged ICMP Redirect Attempt!")
                print(f"    - Spoofed Source (supposed gateway): {src}")
                print(f"    - Target Host: {dst}")
                print(f"    - Details: {line.strip()}")
                alerts += 1

    if alerts == 0:
        print("[+] No anomalous ICMP redirect packets observed in firewall logs.")
    else:
        print(f"[+] Total redirection attempts logged: {alerts}")

if __name__ == "__main__":
    print("=== ICMP Redirect Detection Engine ===")
    analyze_icmp_redirects()
