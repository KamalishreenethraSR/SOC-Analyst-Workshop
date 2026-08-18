# Expected Telemetry & Detector Output

## 1. Expected Log Entries

### iptables Redirect Log (`/var/log/syslog`)
```text
Aug 18 09:20:25 ubuntu-target kernel: ICMP REDIRECT ATTEMPT: IN=eth1 OUT= MAC=... SRC=192.168.56.10 DST=192.168.56.20 ... PROTO=ICMP TYPE=5 CODE=1
```

## 2. Expected `detect.py` Console Output
```text
=== ICMP Redirect Detection Engine ===
[*] Analyzing syslog for ICMP Redirect attempts...
[!] FIREWALL ALERT: Blocked/Logged ICMP Redirect Attempt!
    - Spoofed Source (supposed gateway): 192.168.56.10
    - Target Host: 192.168.56.20
    - Details: Aug 18 09:20:25 ubuntu-target kernel: ICMP REDIRECT ATTEMPT: IN=eth1 OUT= MAC=... SRC=192.168.56.10 DST=192.168.56.20 ... PROTO=ICMP TYPE=5 CODE=1
[+] Total redirection attempts logged: 1
```
