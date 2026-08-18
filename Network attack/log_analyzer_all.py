#!/usr/bin/env python3
# log_analyzer_all.py - Master log analyzer that calls individual detectors.

import os
import subprocess
import sys

ATTACKS = [
    "network_scanning",
    "icmp_flood",
    "syn_flood",
    "udp_flood",
    "arp_spoofing",
    "icmp_redirect",
    "ssh_brute_force",
    "ftp_brute_force",
    "metasploit_reverse_shell",
    "ping_of_death",
    "smurf_attack",
    "icmp_tunneling",
    "dns_tunneling",
    "icmp_exfiltration"
]

def run_analyzer():
    print("==================================================")
    print("        MASTER ATTACK & IMPACT ANALYZER           ")
    print("==================================================")
    
    for attack in ATTACKS:
        detect_script = os.path.join(attack, "log_viewer", "detect.py")
        if os.path.exists(detect_script):
            print(f"\n[*] Executing detector: {detect_script}")
            print("-" * 50)
            try:
                # Execute individual detector
                result = subprocess.run(
                    [sys.executable, detect_script],
                    capture_output=True,
                    text=True,
                    timeout=10
                )
                print(result.stdout)
                if result.stderr:
                    print(f"[-] Errors/Warnings from detector:\n{result.stderr}")
            except subprocess.TimeoutExpired:
                print("[-] Error: Detector execution timed out.")
            except Exception as e:
                print(f"[-] Error executing detector: {e}")
        else:
            print(f"\n[-] Detector script not found: {detect_script}")
            
    print("==================================================")
    print("=== Master Attack Analysis Run Complete ===")

if __name__ == "__main__":
    run_analyzer()
