# Expected Telemetry & Detector Output

## 1. Expected Log Entries

### Auditd Process Execution (`/var/log/audit/audit.log`)
```text
type=SYSCALL msg=audit(1724000000.123:456): arch=c000003e syscall=59 success=yes exit=0 a0=7f45b201a0a0 a1=7f45b201a1d0 a2=7f45b201a2c0 items=2 ppid=1234 pid=5678 auid=4294967295 uid=33 gid=33 euid=33 suid=33 fsuid=33 egid=33 sgid=33 fsgid=33 tty=(none) ses=4294967295 comm="sh" exe="/bin/sh" key="process_execution"
type=EXECVE msg=audit(1724000000.123:456): argc=1 a0="sh"
```

## 2. Expected `detect.py` Console Output
```text
=== Metasploit Reverse Shell Detection Engine ===
[*] Analyzing audit.log for anomalous process executions...
[!] AUDITD ALERT: Anomalous Command Shell execution detected!
    - Binary: sh
    - Raw Audit Log: type=EXECVE msg=audit(1724000000.123:456): argc=1 a0="sh"
[+] Total execution alerts: 1
```
