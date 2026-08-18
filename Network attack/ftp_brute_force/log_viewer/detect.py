#!/usr/bin/env python3
# detect.py - FTP Brute Force detector utility for Ubuntu target logs.

import os
import re
from collections import defaultdict

VSFTPD_LOG = "/var/log/vsftpd.log"
FAIL2BAN_LOG = "/var/log/fail2ban.log"

def analyze_ftp_brute():
    print("[*] Analyzing vsftpd.log for FTP authentication failures...")
    if not os.path.exists(VSFTPD_LOG):
        print(f"[-] Log file {VSFTPD_LOG} not found. Run target setup and run vsftpd.")
        return

    # Pattern for vsftpd failed login attempts
    # Example: Aug 18 09:20:00 [vsftpd] [ftpuser] FAIL LOGIN: Client "192.168.56.10"
    fail_pattern = re.compile(
        r"FAIL LOGIN:\s+Client\s+\"(?P<src>[0-9\.]+)\""
    )

    failures = defaultdict(int)

    with open(VSFTPD_LOG, "r", errors="ignore") as f:
        for line in f:
            match = fail_pattern.search(line)
            if match:
                src = match.group("src")
                failures[src] += 1

    detected = False
    for src, count in failures.items():
        if count >= 5:
            print(f"[!] ALERT: FTP Password Brute-Force attempt detected from Host {src}!")
            print(f"    - Total authentication failures: {count}")
            detected = True

    if not detected:
        print("[+] No anomalous FTP authentication failures found.")

def check_fail2ban_bans():
    print("[*] Checking fail2ban logs for FTP bans...")
    if not os.path.exists(FAIL2BAN_LOG):
        print(f"[-] Fail2ban log file {FAIL2BAN_LOG} not found.")
        return

    # Example: 2026-08-18 09:20:00,123 fail2ban.actions [123]: WARNING [vsftpd] Ban 192.168.56.10
    ban_pattern = re.compile(r"\[vsftpd\].*Ban (?P<src>[0-9\.]+)")

    bans = 0
    with open(FAIL2BAN_LOG, "r", errors="ignore") as f:
        for line in f:
            match = ban_pattern.search(line)
            if match:
                src = match.group("src")
                print(f"[!] FAIL2BAN BAN ALERT: Host {src} has been actively blocked for FTP Brute Force.")
                bans += 1

    if bans == 0:
        print("[+] No active FTP Fail2ban bans observed in log file.")

if __name__ == "__main__":
    print("=== FTP Brute Force Detection Engine ===")
    analyze_ftp_brute()
    print("-" * 50)
    check_fail2ban_bans()
