# Expected Telemetry & Detector Output

## 1. Expected Log Entries

### Suricata Alert Log (`/var/log/suricata/fast.log`)
```text
08/18/2026-09:21:30.123456  [**] [1:1000006:1] DNS Tunneling - Long Subdomain Query [**] [Classification: Policy Violation] [Priority: 1] {UDP} 192.168.56.10:53421 -> 192.168.56.20:53
```

## 2. Expected `detect.py` Console Output
```text
=== DNS Tunneling Detection Engine ===
[*] Analyzing Suricata alerts for DNS Tunneling signatures...
[!] IDS ALERT: DNS Tunneling Activity Detected!
    - Event details: 08/18/2026-09:21:30.123456  [**] [1:1000006:1] DNS Tunneling - Long Subdomain Query [**] [Priority: 1] {UDP} 192.168.56.10:53421 -> 192.168.56.20:53
[+] Total DNS Tunnel alerts: 1
```
