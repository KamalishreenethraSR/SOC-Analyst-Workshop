# Expected Telemetry & Detector Output

## 1. Expected Log Entries

### iptables Limit Exceeded Warning (`/var/log/syslog`)
```text
Aug 18 09:20:15 ubuntu-target kernel: LIMIT EXCEEDED UDP: IN=eth1 OUT= MAC=... SRC=192.168.56.10 DST=192.168.56.20 ... PROTO=UDP SPT=56321 DPT=53
```

## 2. Expected `detect.py` Console Output
```text
=== UDP Flood Detection Engine ===
[*] Analyzing syslog for UDP flood indicators...
[!] ALERT: Potential UDP Flooding detected from Host 192.168.56.10!
    - Blocked/Logged UDP packet events: 1250
    - Destination ports affected: [53]... (showing first 5)
```
