# Expected Telemetry & Detector Output

## 1. Expected Log Entries

### Suricata Alert Log (`/var/log/suricata/fast.log`)
```text
08/18/2026-09:21:20.123456  [**] [1:1000004:1] ICMP Tunneling - Large Payload Echo Request [**] [Classification: Network Anomaly] [Priority: 2] {ICMP} 192.168.56.10 -> 192.168.56.20
08/18/2026-09:21:21.123456  [**] [1:1000005:1] ICMP Tunneling - Non-standard Echo Payload [**] [Classification: Network Anomaly] [Priority: 2] {ICMP} 192.168.56.10 -> 192.168.56.20
```

## 2. Expected `detect.py` Console Output
```text
=== ICMP Tunneling Detection Engine ===
[*] Analyzing Suricata alerts for ICMP Tunneling signatures...
[!] IDS ALERT: ICMP Tunneling Activity Detected!
    - Event details: 08/18/2026-09:21:20.123456  [**] [1:1000004:1] ICMP Tunneling - Large Payload Echo Request [**] [Priority: 2] {ICMP} 192.168.56.10 -> 192.168.56.20
[+] Total ICMP Tunnel alerts: 2
```
