# Expected Telemetry & Detector Output

## 1. Expected Log Entries

### iptables Broadcast Warning (`/var/log/syslog`)
```text
Aug 18 09:21:10 ubuntu-target kernel: ICMP BROADCAST RECV: IN=eth1 OUT= MAC=... SRC=192.168.56.10 DST=192.168.56.255 ... PROTO=ICMP TYPE=8 CODE=0
```

## 2. Expected `detect.py` Console Output
```text
=== Smurf Attack Detection Engine ===
[*] Analyzing syslog for Smurf Attack indicators...
[!] ALERT: High Broadcast ICMP activity detected (Potential Smurf Sweep)!
    - Packets sent to broadcast by Host 192.168.56.10: 412
```
