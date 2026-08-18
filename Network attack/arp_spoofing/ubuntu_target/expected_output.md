# Expected Telemetry & Detector Output

## 1. Expected Log Entries

### Arpwatch Alert (`/var/log/syslog`)
```text
Aug 18 09:20:20 ubuntu-target arpwatch: flip flop 192.168.56.1 00:0c:29:aa:bb:cc (00:0c:29:44:55:66)
```

## 2. Expected `detect.py` Console Output
```text
=== ARP Spoofing Detection Engine ===
[*] Analyzing syslog for arpwatch ARP spoofing alerts...
[!] ARPWATCH ALERT: Potential ARP Poisoning Event!
    - Type: FLIP FLOP
    - Affected IP: 192.168.56.1
    - New/Flapping MAC: 00:0c:29:aa:bb:cc
    - Raw Event: Aug 18 09:20:20 ubuntu-target arpwatch: flip flop 192.168.56.1 00:0c:29:aa:bb:cc (00:0c:29:44:55:66)
[+] Total ARP anomalies detected: 1
```
