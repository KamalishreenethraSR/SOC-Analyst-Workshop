# Lab 5.1 — Endpoint Detection, Threat Hunt, and Memory Triage

**Module:** [Module 5 — Endpoint and Network Monitoring](../docs/05-endpoint-and-network-monitoring.md)

## Scenario

A Windows victim VM will have a simulated privilege-escalation and persistence chain executed on it by the instructor/automation, plus a memory image of a compromised host is provided for offline triage.

## Step-by-Step

1. Install and enrol a Wazuh agent on the Windows victim VM; confirm it reports into the Wazuh manager dashboard.
2. Instructor triggers a simulated attack chain: creation of a new local admin user (Event ID 4720/4732) and a persistence scheduled task (Event ID 4698). Students must detect both in the Wazuh dashboard within 10 minutes and record the raw event details.
3. On the Linux host, configure an auditd watch rule: auditctl -w /etc/passwd -p wa -k passwd_watch, trigger a change, and confirm detection via ausearch -k passwd_watch.
4. Using Sysinternals Process Explorer/Autoruns (or Velociraptor VQL / PowerShell Get-CimInstance Win32_Process), hunt for suspicious parent-child process relationships, e.g., winword.exe or outlook.exe spawning powershell.exe or cmd.exe — a classic T1566 → T1059 chain.
5. Document the hunt hypothesis first ('If a macro-enabled document executed, I expect an Office process to be the parent of a shell process'), then the query/method used, then the findings.
6. Load the provided memory image in Volatility3: vol.py -f victim.mem windows.pslist to list processes; identify a suspicious/unexpected process.
7. Run vol.py -f victim.mem windows.netscan to correlate the suspicious process with an external network connection (potential C2).
8. Summarize findings in a one-page mini forensic note: suspicious process name/PID, parent process, associated network indicator, and recommended next step.

## Expected Outcomes

- Wazuh alerts correctly captured for both the new-admin-user and scheduled-task persistence events
- A documented, hypothesis-driven hunt with a genuine finding (or a documented null result)
- A memory-triage note identifying at least one suspicious process and its network artifact

## Hands-on Lab Challenge

Given a second memory image, identify the malicious process, its parent process, and any associated network connection within 30 minutes, and state which MITRE ATT&CK technique the behavior most likely represents.


