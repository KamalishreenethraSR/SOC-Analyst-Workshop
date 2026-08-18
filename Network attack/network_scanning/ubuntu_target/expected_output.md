# Expected Telemetry & Detector Output

## 1. Expected Log Entries

### UFW Syslog Match
```text
Aug 18 09:20:00 ubuntu-target kernel: [UFW BLOCK] IN=eth1 OUT= MAC=00:0c:29:11:22:33:00:0c:29:44:55:66:08:00 SRC=192.168.56.10 DST=192.168.56.20 LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=45231 DF PROTO=TCP SPT=52342 DPT=80 WINDOW=0 RES=0x00 SYN URGP=0
```

### Suricata Alert Log (`/var/log/suricata/fast.log`)
```text
08/18/2026-09:20:00.123456  [**] [1:1000001:1] SCAN TCP port sweep [**] [Classification: Attempted Information Leak] [Priority: 3] {TCP} 192.168.56.10:45231 -> 192.168.56.20:80
```

## 2. Expected `detect.py` Console Output
```text
=== Network Scanning Detection Engine ===
[*] Analyzing UFW firewall logs for potential port sweeps...
[!] ALERT: Potential Port Scan detected from Host 192.168.56.10!
    - Blocked unique destination ports: 45
    - Target Ports: [21, 22, 23, 25, 53, 80, 110, 139, 443, 445]... (showing first 10)
--------------------------------------------------
[*] Analyzing Suricata IDS alerts for scanning signatures...
[!] Suricata Alert: 08/18/2026-09:20:00.123456  [**] [1:1000001:1] SCAN TCP port sweep [**] [Priority: 3] {TCP} 192.168.56.10:45231 -> 192.168.56.20:80
[+] Total Suricata scan alerts: 1
```
