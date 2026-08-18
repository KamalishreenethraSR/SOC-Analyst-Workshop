# Expected Telemetry & Detector Output

## 1. Expected Log Entries

### TCP Kernel Alert (`/var/log/syslog`)
```text
Aug 18 09:20:10 ubuntu-target kernel: TCP: Possible SYN flooding on port 80. Sending cookies. Check System logs.
```

### iptables Limit Exceeded Warning (`/var/log/syslog`)
```text
Aug 18 09:20:10 ubuntu-target kernel: LIMIT EXCEEDED TCP SYN: IN=eth1 OUT= MAC=... SRC=192.168.56.10 DST=192.168.56.20 ... PROTO=TCP SPT=45832 DPT=80 SYN
```

## 2. Expected `detect.py` Console Output
```text
=== TCP SYN Flood Detection Engine ===
[*] Analyzing syslog for TCP SYN flood indicators...
[!] KERNEL ALERT: Active SYN Flood Mitigation triggered on port 80!
[!] FIREWALL ALERT: High SYN rate logged from Host 192.168.56.10!
    - Blocked/Logged TCP SYN packet events: 834
```
