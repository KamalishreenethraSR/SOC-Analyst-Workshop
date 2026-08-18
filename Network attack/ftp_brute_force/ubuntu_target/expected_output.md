# Expected Telemetry & Detector Output

## 1. Expected Log Entries

### FTP Failures (`/var/log/vsftpd.log`)
```text
Aug 18 09:20:40 [vsftpd] [ftpuser] FAIL LOGIN: Client "192.168.56.10"
Aug 18 09:20:41 [vsftpd] [anonymous] FAIL LOGIN: Client "192.168.56.10"
```

### Fail2ban Ban (`/var/log/fail2ban.log`)
```text
2026-08-18 09:20:45,123 fail2ban.actions [123]: WARNING [vsftpd] Ban 192.168.56.10
```

## 2. Expected `detect.py` Console Output
```text
=== FTP Brute Force Detection Engine ===
[*] Analyzing vsftpd.log for FTP authentication failures...
[!] ALERT: FTP Password Brute-Force attempt detected from Host 192.168.56.10!
    - Total authentication failures: 8
--------------------------------------------------
[*] Checking fail2ban logs for FTP bans...
[!] FAIL2BAN BAN ALERT: Host 192.168.56.10 has been actively blocked for FTP Brute Force.
[+] Total active FTP Fail2ban bans observed in log file: 1
```
