# Lab 5.1 — Solution: Endpoint Detection, Threat Hunt, and Memory Triage

**Module:** [Module 5 — Endpoint and Network Monitoring](../../docs/05-endpoint-and-network-monitoring.md)

---

## Step 1 — Install and Enrol Wazuh Agent on Windows VM

```powershell
# Verify agent is running and connected
Get-Service WazuhSvc
# Expected: Status: Running

# Check connection in agent log
Get-Content "C:\Program Files (x86)\ossec-agent\ossec.log" -Tail 10
# Expected: "ossec: Agent connected" or "ossec: Agent started"
```

**Wazuh Dashboard Verification:**
1. Navigate to Wazuh Dashboard → Agents
2. Find the Windows VM hostname
3. Status should show **Active** (green dot)
4. Click on the agent → Events → shows recent alerts

---

## Step 2 — Detect Simulated Attack Chain (Event IDs 4720/4698)

After the instructor/automation triggers the simulated attack:

### Detect New Local Admin User (Event ID 4720 + 4732)

**Wazuh Dashboard → Security events → Filter:**
```
rule.id: 18154 (User account created)
rule.id: 18160 (User added to local Administrators group)
```

**Raw Event Details to Record:**

```
Event ID 4720 — User Account Created:
  Subject: Security ID:   S-1-5-21-...-500 (SYSTEM or admin account)
  New Account:
    Account Name:   backdoor_admin
    Account Domain: CORP
  Caller:
    Security ID:   S-1-5-21-...-1001 (attacker context)

Event ID 4732 — Member Added to Security-Enabled Local Group:
  Member:
    Security ID:   S-1-5-21-...-1002  (backdoor_admin SID)
  Group Name:     Administrators
  Group Domain:   Builtin
```

**Expected Wazuh Alert:**
```
Rule: 18154 — Windows user account created.
     severity: 12 (high)
     timestamp: 2024-08-14T15:22:04
     hostname:  VICTIMWIN10
     data.win.eventdata.targetUserName: backdoor_admin
```

### Detect Scheduled Task Persistence (Event ID 4698)

**Wazuh Dashboard filter:**
```
rule.id: 18145 (Scheduled task created)
```

```
Event ID 4698 — Scheduled Task Created:
  Subject:
    Account Name:   backdoor_admin
  Task Information:
    Task Name:     \Microsoft\Windows\BackdoorTask
    Task Content:  <Actions><Exec><Command>C:\Windows\Temp\beacon.exe</Command></Exec></Actions>
```

---

## Step 3 — auditd Watch Rule on Linux (Ubuntu VM)

**Apply the watch rule:**
```bash
sudo auditctl -w /etc/passwd -p wa -k passwd_watch
```

**Trigger a change:**
```bash
# As root, append a dummy entry (remove afterwards)
sudo bash -c 'echo "# test entry" >> /etc/passwd'

# Verify detection
sudo ausearch -k passwd_watch
```

**Expected ausearch Output:**
```
----
type=PROCTITLE msg=audit(1723647722.415:123): proctitle=...
type=PATH msg=audit(1723647722.415:123): item=0 name="/etc/passwd" inode=... dev=... mode=... ouid=0 ogid=0 rdev=00:00 nametype=NORMAL
type=SYSCALL msg=audit(1723647722.415:123): arch=c000003e syscall=2 success=yes exit=3 a0=... a1=401 a2=1a4 a3=...
 auid=1001 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0
 tty=pts0 ses=4 comm="bash" exe="/bin/bash" key="passwd_watch"
```

**Clean up test entry:**
```bash
sudo sed -i '/# test entry/d' /etc/passwd
```

---

## Step 4 — Hunt: Suspicious Parent-Child Process Relationships

### Hunt Hypothesis

```
HYPOTHESIS: If a macro-enabled Office document was opened and executed,
I expect to find an Office application process (winword.exe, excel.exe,
or outlook.exe) as the parent of a shell interpreter process
(powershell.exe or cmd.exe).

TECHNIQUE: T1566 (Phishing) → T1059 (Command and Scripting Interpreter)
DETECTION: Parent-child process relationship in Sysmon Event ID 1
```

### Hunt Method: Sysmon via Kibana/Wazuh

**KQL Query (Kibana/Wazuh):**
```kql
event.code:1 AND process.parent.name:(winword.exe OR excel.exe OR outlook.exe OR powerpnt.exe)
  AND process.name:(powershell.exe OR cmd.exe OR wscript.exe OR cscript.exe OR mshta.exe)
```

**PowerShell Hunt Query:**
```powershell
# Hunt via Get-WinEvent
$events = Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" |
  Where-Object { $_.Id -eq 1 } |
  Where-Object { $_.Message -match "ParentImage.*winword|ParentImage.*excel|ParentImage.*outlook" } |
  Where-Object { $_.Message -match 'Image.*powershell|Image.*cmd\.exe' }

$events | ForEach-Object {
  $xml = [xml]$_.ToXml()
  [PSCustomObject]@{
    Time       = $_.TimeCreated
    Image      = ($xml.Event.EventData.Data | Where-Object Name -eq Image).'#text'
    ParentImage = ($xml.Event.EventData.Data | Where-Object Name -eq ParentImage).'#text'
    CommandLine = ($xml.Event.EventData.Data | Where-Object Name -eq CommandLine).'#text'
  }
} | Format-Table -AutoSize
```

### Expected Hunting Findings

```
Time                    Image                    ParentImage              CommandLine
----                    -----                    -----------              -----------
2024-08-14 15:20:33    C:\Windows\...\powershell.exe  C:\...\WINWORD.EXE  powershell.exe -ExecutionPolicy Bypass -EncodedCommand JABW...
```

> **If no results found:** Document as a null result with "No evidence of Office → shell execution during the observed time window. Hypothesis not confirmed for this time period."

---

## Step 5 — Threat Hunt Documentation

```
HUNT REPORT — Lab 5.1
======================
Analyst:      <Student Name>
Date:         2024-08-14
Duration:     ~20 minutes

HYPOTHESIS:
  If a macro-enabled Office document was executed, I expect to find
  WinWord.exe (or similar Office process) as the parent of a command
  interpreter (PowerShell.exe or cmd.exe).

QUERY/METHOD:
  Sysmon Event ID 1 (Process Create) via Kibana KQL:
  event.code:1 AND process.parent.name:winword.exe AND process.name:powershell.exe

SCOPE:
  Time window: 2024-08-14 15:00–15:45 UTC
  Host: VICTIMWIN10

FINDINGS:
  CONFIRMED — WinWord.exe spawned PowerShell.exe at 15:20:33 UTC
  CommandLine: powershell.exe -ExecutionPolicy Bypass -EncodedCommand JABW...
  Associated Sysmon EventRecordID: 12345

MITRE ATT&CK:
  T1566.001 → T1059.001 (Phishing → PowerShell Execution)

RECOMMENDED NEXT STEP:
  Decode the base64 -EncodedCommand payload and analyse for C2 IOCs.
  Isolate VICTIMWIN10 from network pending full investigation.
```

---

## Step 6 — Volatility3: Process Listing

```bash
# List all processes
vol.py -f ~/lab-evidence/victim.mem windows.pslist

# Expected output (excerpt):
# PID   PPID  ImageFileName   Offset    Threads  Handles
# 4     0     System          0x...     114      5547
# 304   4     smss.exe        0x...     2        29
# 392   380   csrss.exe       0x...     10       444
# ...
# 3412  5120  svchost.exe     0x...     12       ...     ← SUSPICIOUS (parent is not services.exe)
# 3592  3412  rundll32.exe    0x...     4        ...     ← SUSPICIOUS
```

**Identify suspicious process:**
```bash
# Check parent processes for anomalies
vol.py -f ~/lab-evidence/victim.mem windows.pstree

# Suspicious patterns to look for:
#   - svchost.exe with parent other than services.exe (PID 676)
#   - cmd.exe or powershell.exe with unusual parent
#   - Process names that look like system processes but aren't (e.g., "svch0st.exe")
#   - Processes running from temp directories
```

---

## Step 7 — Volatility3: Network Connections

```bash
# Identify network connections for the suspicious process
vol.py -f ~/lab-evidence/victim.mem windows.netscan

# Expected output (excerpt):
# Offset  Proto  LocalAddr    LocalPort  ForeignAddr      ForeignPort  State  PID  Owner
# 0x...   TCPv4  10.10.1.45   49812      185.220.101.55   443          ESTABLISHED  3412  svchost.exe
```

**Correlating findings:**
```
Suspicious process: svchost.exe (PID 3412)
  - Parent: PID 5120 (powershell.exe — spawned from WinWord.exe)
  - Network: Established connection to 185.220.101.55:443 (external — known C2 IP from Lab 4.1)
  - This confirms: T1059.001 → T1543.003 (Create/Modify System Process) or T1055 (Process Injection)
```

---

## Mini Forensic Note

```
MEMORY TRIAGE FORENSIC NOTE — Lab 5.1
=======================================
Analyst:    <Student Name>
Date:       2024-08-14
Image:      victim.mem (VICTIMWIN10 — captured 15:45 UTC)

SUSPICIOUS PROCESS:
  Name:    svchost.exe
  PID:     3412
  PPID:    5120 (powershell.exe — anomalous parent for svchost)

PARENT PROCESS:
  Name:    powershell.exe
  PID:     5120
  PPID:    7812 (WINWORD.EXE)
  Note:    Part of a macro execution chain (T1566.001 → T1059.001)

NETWORK INDICATOR:
  Protocol:  TCP
  LocalIP:   10.10.1.45:49812
  Foreign:   185.220.101.55:443  (ESTABLISHED)
  Note:      185.220.101.55 is a confirmed C2 IP (AbuseIPDB score: 100)

RECOMMENDED NEXT STEP:
  1. Isolate VICTIMWIN10 from all network access immediately
  2. Dump process memory of PID 3412 for malware analysis
  3. Block 185.220.101.55 at perimeter firewall
  4. Search all endpoints for connections to 185.220.101.55
  5. Open TheHive case — reference IOCs from Lab 4.1 MISP event

MITRE ATT&CK:
  T1566.001  Phishing: Spearphishing Attachment (initial vector)
  T1059.001  PowerShell execution
  T1543.003  or T1055 — svchost anomaly (possible hollowing/injection)
  T1071.001  C2 over HTTPS to external IP
```

---

## Lab Challenge Solution — Second Memory Image

```bash
# Step 1: Process list
vol.py -f ~/lab-evidence/challenge.mem windows.pslist

# Step 2: Process tree to find unusual parent-child
vol.py -f ~/lab-evidence/challenge.mem windows.pstree

# Step 3: Network connections
vol.py -f ~/lab-evidence/challenge.mem windows.netscan

# Step 4: Process command line (what was the process launched with?)
vol.py -f ~/lab-evidence/challenge.mem windows.cmdline --pid <SUSPICIOUS_PID>

# Step 5: Identify MITRE technique
# Common patterns:
#   cmd.exe ← powershell.exe ← winword.exe    → T1566 → T1059
#   lsass access from non-system process       → T1003.001 (LSASS memory)
#   mshta.exe or regsvr32.exe unusual parent   → T1218 (Signed Binary Proxy Execution)
```

---

[⬅ Setup](./setup.md) | [Grading Rubric ➡](./grading-rubric.md)
