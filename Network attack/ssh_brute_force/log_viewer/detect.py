#!/usr/bin/env python3
# detect.py - SSH Brute Force detector utility for Ubuntu target logs.

import os
import re
from collections import defaultdict

AUTH_LOG = "/var/log/auth.log"
FAIL2BAN_LOG = "/var/log/fail2ban.log"

def analyze_ssh_brute():
    print("[*] Analyzing auth.log for SSH authentication failures...")
    if not os.path.exists(AUTH_LOG):
        print(f"[-] Log file {AUTH_LOG} not found.")
        return

    # Pattern for failed password attempts
    # Example: Aug 18 09:20:00 target sshd[1234]: Failed password for invalid user admin from 192.168.56.10 port 45832 ssh2
    # Example: Aug 18 09:20:00 target sshd[1234]: Failed password for root from 192.168.56.10 port 45832 ssh2
    fail_pattern = re.compile(
        r"sshd\[\d+\].*Failed password for (invalid user )?(?P<user>\S+) from (?P<src>[0-9\.]+)"
    )

    failures = defaultdict(int)
    users_attempted = defaultdict(set)

    with open(AUTH_LOG, "r", errors="ignore") as f:
        for line in f:
            match = fail_pattern.search(line)
            if match:
                src = match.group("src")
                user = match.group("user")
                failures[src] += 1
                users_attempted[src].add(user)

    detected = False
    for src, count in failures.items():
        if count >= 5:
            print(f"[!] ALERT: SSH Password Brute-Force attempt detected from Host {src}!")
            print(f"    - Total authentication failures: {count}")
            print(f"    - User accounts targeted: {list(users_attempted[src])}")
            detected = True

    if not detected:
        print("[+] No anomalous SSH authentication failures found.")

def check_fail2ban_bans():
    print("[*] Checking fail2ban logs for SSH bans...")
    if not os.path.exists(FAIL2BAN_LOG):
        print(f"[-] Fail2ban log file {FAIL2BAN_LOG} not found.")
        return

    # Example: 2026-08-18 09:20:00,123 fail2ban.actions [123]: WARNING [sshd] Ban 192.168.56.10
    ban_pattern = re.compile(r"\[sshd\].*Ban (?P<src>[0-9\.]+)")

    bans = 0
    with open(FAIL2BAN_LOG, "r", errors="ignore") as f:
        for line in f:
            match = ban_pattern.search(line)
            if match:
                src = match.group("src")
                print(f"[!] FAIL2BAN BAN ALERT: Host {src} has been actively blocked for SSH Brute Force.")
                bans += 1

    if bans == 0:
        print("[+] No active SSH Fail2ban bans observed in log file.")

if __name__ == "__main__":
    print("=== SSH Brute Force Detection Engine ===")
    analyze_ssh_brute()
    print("-" * 50)
    check_fail2ban_bans()
