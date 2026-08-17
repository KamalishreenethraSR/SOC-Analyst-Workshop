#!/usr/bin/env python3
"""
generate-synthetic.py — Generates safe synthetic dataset files for SD0601 labs
Creates realistic JSON/Log events without real malware or real user credentials.
"""

import os
import json
import time

DATASET_DIR = os.path.join(os.path.dirname(__file__), "../../datasets/synthetic")
os.makedirs(DATASET_DIR, exist_ok=True)

def generate_windows_security():
    events = [
        {
            "EventID": 4625,
            "Channel": "Security",
            "Computer": "VICTIMWIN10",
            "TimeCreated": time.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "EventData": {
                "TargetUserName": "Administrator",
                "WorkstationName": "VICTIMWIN10",
                "IpAddress": "10.60.0.101",
                "Status": "0xC000006D",
                "SubStatus": "0xC000006A"
            }
        },
        {
            "EventID": 4720,
            "Channel": "Security",
            "Computer": "VICTIMWIN10",
            "TimeCreated": time.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "EventData": {
                "TargetUserName": "backdoor_admin",
                "TargetDomainName": "VICTIMWIN10",
                "SubjectUserName": "Administrator"
            }
        },
        {
            "EventID": 4698,
            "Channel": "Security",
            "Computer": "VICTIMWIN10",
            "TimeCreated": time.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "EventData": {
                "TaskName": "\\Microsoft\\Windows\\BackdoorTask",
                "SubjectUserName": "backdoor_admin",
                "TaskContent": "<Actions><Exec><Command>C:\\Windows\\Temp\\beacon.exe</Command></Exec></Actions>"
            }
        }
    ]
    with open(os.path.join(DATASET_DIR, "windows-security.json"), "w") as f:
        json.dump(events, f, indent=2)
    print("[OK] Generated windows-security.json")

def generate_sysmon_events():
    events = [
        {
            "EventID": 1,
            "Channel": "Microsoft-Windows-Sysmon/Operational",
            "Computer": "VICTIMWIN10",
            "TimeCreated": time.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "EventData": {
                "Image": "C:\\Windows\\System32\\powershell.exe",
                "CommandLine": "powershell.exe -ExecutionPolicy Bypass -EncodedCommand JABW...",
                "ParentImage": "C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE",
                "User": "VICTIMWIN10\\student"
            }
        }
    ]
    with open(os.path.join(DATASET_DIR, "sysmon-events.json"), "w") as f:
        json.dump(events, f, indent=2)
    print("[OK] Generated sysmon-events.json")

def generate_linux_auth():
    logs = [
        f"{time.strftime('%b %d %H:%M:%S')} ubuntusoc sshd[1234]: Failed password for invalid user admin from 10.60.0.100 port 49812 ssh2\n",
        f"{time.strftime('%b %d %H:%M:%S')} ubuntusoc sshd[1235]: Failed password for invalid user root from 10.60.0.100 port 49814 ssh2\n",
        f"{time.strftime('%b %d %H:%M:%S')} ubuntusoc sudo: student : TTY=pts/0 ; PWD=/home/student ; USER=root ; COMMAND=/bin/bash\n"
    ]
    with open(os.path.join(DATASET_DIR, "linux-auth.log"), "w") as f:
        f.writelines(logs)
    print("[OK] Generated linux-auth.log")

if __name__ == "__main__":
    generate_windows_security()
    generate_sysmon_events()
    generate_linux_auth()
