# Expected Telemetry & Detector Output

## 1. Expected Log Entries

### Suricata Alert Log (`/var/log/suricata/fast.log`)
```text
08/18/2026-09:21:40.123456  [**] [1:1000009:1] ICMP Exfiltration - Encapsulated ELF Header [**] [Classification: Data Leak] [Priority: 1] {ICMP} 192.168.56.10 -> 192.168.56.20
```

## 2. Expected `detect.py` Console Output
```text
=== ICMP Exfiltration Detection Engine ===
[*] Analyzing Suricata alerts for ICMP Exfiltration signatures...
[!] IDS ALERT: ICMP Data Exfiltration Activity Detected!
    - Event details: 08/18/2026-09:21:40.123456  [**] [1:1000009:1] ICMP Exfiltration - Encapsulated ELF Header [**] [Priority: 1] {ICMP} 192.168.56.10 -> 192.168.56.20
[+] Total ICMP Exfil alerts: 1
```
