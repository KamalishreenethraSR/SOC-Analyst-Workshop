# Expected Telemetry & Detector Output

## 1. Expected Log Entries

### iptables Limit Exceeded Warning (`/var/log/syslog`)
```text
Aug 18 09:20:05 ubuntu-target kernel: LIMIT EXCEEDED ICMP: IN=eth1 OUT= MAC=00:0c:29:11:22:33:00:0c:29:44:55:66:08:00 SRC=192.168.56.10 DST=192.168.56.20 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=12345 PROTO=ICMP TYPE=8 CODE=0 ID=5623 SEQ=1
```

## 2. Expected `detect.py` Console Output
```text
=== ICMP Flood Detection Engine ===
[*] Analyzing syslog for ICMP flood signatures...
[!] ALERT: ICMP Flooding detected from Host 192.168.56.10!
    - Blocked/Logged high-rate ICMP packet events: 1452
```
