#!/usr/bin/env python3
# detect.py - Reverse Shell detector utility for Ubuntu target logs.

import os
import re

AUDIT_LOG = "/var/log/audit/audit.log"

def analyze_reverse_shell():
    print("[*] Analyzing audit.log for anomalous process executions...")
    if not os.path.exists(AUDIT_LOG):
        print(f"[-] Audit log file {AUDIT_LOG} not found. Run target setup and ensure auditd is running.")
        return

    # Check for process executions involving shell programs triggered by network daemons
    # Example: type=SYSCALL msg=audit(123): arch=c000003e syscall=59 success=yes exit=0 ... key="process_execution"
    # Example: type=EXECVE msg=audit(123): argc=1 a0="sh"
    # Example: type=EXECVE msg=audit(123): argc=3 a0="bash" a1="-i"
    
    # We will search for execve invocations of shell programs
    exec_pattern = re.compile(
        r'type=EXECVE.*a0="(?P<bin>/bin/sh|sh|/bin/bash|bash|/usr/bin/python3|python3|nc|netcat|perl|ruby)"'
    )

    detections = 0
    with open(AUDIT_LOG, "r", errors="ignore") as f:
        for line in f:
            match = exec_pattern.search(line)
            if match:
                shell_bin = match.group("bin")
                print(f"[!] AUDITD ALERT: Anomalous Command Shell execution detected!")
                print(f"    - Binary: {shell_bin}")
                print(f"    - Raw Audit Log: {line.strip()}")
                detections += 1

    if detections == 0:
        print("[+] No anomalous interactive shell commands observed in audit logs.")
    else:
        print(f"[+] Total execution alerts: {detections}")

if __name__ == "__main__":
    print("=== Metasploit Reverse Shell Detection Engine ===")
    analyze_reverse_shell()
