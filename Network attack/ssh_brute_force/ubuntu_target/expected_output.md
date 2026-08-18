# Expected Telemetry & Detector Output

## 1. Expected Log Entries

### SSH Failures (`/var/log/auth.log`)
```text
Aug 18 09:20:30 ubuntu-target sshd[1234]: Failed password for root from 192.168.56.10 port 45832 ssh2
Aug 18 09:20:31 ubuntu-target sshd[1236]: Failed password for invalid user admin from 192.168.56.10 port 45834 ssh2
```

### Fail2ban Ban (`/var/log/fail2ban.log`)
```text
2026-08-18 09:20:35,123 fail2ban.actions [123]: WARNING [sshd] Ban 192.168.56.10
```

## 2. Expected `detect.py` Console Output
```text
=== SSH Brute Force Detection Engine ===
[*] Analyzing auth.log for SSH authentication failures...
[!] ALERT: SSH Password Brute-Force attempt detected from Host 192.168.56.10!
    - Total authentication failures: 12
    - User accounts targeted: ['root', 'admin']
--------------------------------------------------
[*] Checking fail2ban logs for SSH bans...
[!] FAIL2BAN BAN ALERT: Host 192.168.56.10 has been actively blocked for SSH Brute Force.
[+] Total active SSH Fail2ban bans observed in log file: 1
```
