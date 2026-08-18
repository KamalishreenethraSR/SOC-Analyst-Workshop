# Expected Telemetry & Detector Output

## 1. Expected Log Entries

### Suricata Alert Log (`/var/log/suricata/fast.log`)
```text
08/18/2026-09:21:00.123456  [**] [1:1000003:1] ICMP Large Packet - Possible Ping of Death [**] [Classification: Bad Traffic] [Priority: 2] {ICMP} 192.168.56.10 -> 192.168.56.20
```

## 2. Expected `detect.py` Console Output
```text
=== Ping of Death Detection Engine ===
[*] Analyzing Suricata alerts for Ping of Death...
[!] IDS ALERT: Oversized ICMP Packet (Ping of Death) Triggered!
    - Event details: 08/18/2026-09:21:00.123456  [**] [1:1000003:1] ICMP Large Packet - Possible Ping of Death [**] [Priority: 2] {ICMP} 192.168.56.10 -> 192.168.56.20
[+] Total PoD alerts: 1
```
