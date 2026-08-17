# Lab 1.1 — Solution: ATT&CK Mapping & Ticket Triage

**Module:** [Module 1 — SOC Fundamentals](../../docs/01-soc-fundamentals.md)

---

## Part 1 — ATT&CK Navigator Mapping

### Attack Narrative

> Phishing email → macro execution → PowerShell download → scheduled task persistence → credential dumping → lateral RDP

### Completed Technique Mapping

| Stage | Description | Tactic | Tactic ID | Technique | Technique ID |
|-------|-------------|--------|-----------|-----------|--------------|
| 1 | Phishing email with malicious attachment | Initial Access | TA0001 | Phishing: Spearphishing Attachment | T1566.001 |
| 2 | Macro execution spawns child process | Execution | TA0002 | User Execution: Malicious File | T1204.002 |
| 3 | PowerShell downloads second-stage payload | Command & Control / Execution | TA0002 / TA0011 | Command and Scripting Interpreter: PowerShell | T1059.001 |
| 3b | File download from C2 server | Command & Control | TA0011 | Ingress Tool Transfer | T1105 |
| 4 | Scheduled task created for persistence | Persistence | TA0003 | Scheduled Task/Job: Scheduled Task | T1053.005 |
| 5 | Credential dumping from memory | Credential Access | TA0006 | OS Credential Dumping | T1003 |
| 6 | Lateral movement via RDP | Lateral Movement | TA0008 | Remote Services: Remote Desktop Protocol | T1021.001 |

> **Navigator Layer JSON:** See [`assets/attack-navigator-layer.json`](./assets/attack-navigator-layer.json)

---

### Navigator Step-by-Step

```
Step 1: Open https://mitre-attack.github.io/attack-navigator/
Step 2: Create New Layer → Enterprise ATT&CK (v14+)
Step 3: Name the layer 'Lab1-<StudentID>'

For each technique below:
  - Use the search bar (🔍) to find the Technique ID
  - Click the technique cell to select it
  - Click "Fill color" and choose a highlight color
  - Add a comment in the side panel: describe what stage it maps to

Techniques to highlight:
  T1566.001  (Phishing: Spearphishing Attachment)
  T1204.002  (User Execution: Malicious File)
  T1059.001  (PowerShell)
  T1105      (Ingress Tool Transfer)
  T1053.005  (Scheduled Task)
  T1003      (OS Credential Dumping)
  T1021.001  (Remote Desktop Protocol)

Step 4: Download Layer → save as Lab1-<StudentID>.json
```

---

## Part 2 — Mock Ticket Triage

### Escalation Matrix Reference

| Priority | Criteria |
|----------|---------|
| P1 — Critical | Active breach, confirmed TP, spreading/data exfil in progress |
| P2 — High | Confirmed TP, contained or not yet spreading; requires immediate investigation |
| P3 — Medium | Likely TP but unconfirmed; or FP requiring tuning; worth investigating in current shift |
| P4 — Low | Benign-Positive or FP, low risk; log and monitor |

### Ticket Queue — Full Triage Answers

---

#### Ticket #001 — Suspicious PowerShell Execution

> **Alert:** PowerShell launched with `-EncodedCommand` flag from `winword.exe` on WORKSTATION-07

**Classification:** ✅ True Positive (TP)  
**Priority:** P2 — High  
**Justification:** WinWord spawning PowerShell is a classic macro execution chain (T1566.001 → T1059.001). Encoded command flag is strongly indicative of obfuscation to evade command-line logging. Immediate investigation of the encoded payload is required. Isolate host pending analysis.

---

#### Ticket #002 — Failed Login Burst

> **Alert:** 47 failed logins for `admin` account from `10.10.5.22` in 4 minutes (Event ID 4625)

**Classification:** ✅ True Positive (TP)  
**Priority:** P2 — High  
**Justification:** Volume (47 attempts in 4 min) and uniform target account are consistent with an automated brute-force attack (T1110.001). Source IP `10.10.5.22` is internal — check if this host is compromised. Escalate if lockout policy is not triggered.

---

#### Ticket #003 — Antivirus EICAR Detection

> **Alert:** AV detected EICAR test file in C:\Users\jsmith\Downloads\eicar.com

**Classification:** ⚠️ Benign-Positive (BP)  
**Priority:** P4 — Low  
**Justification:** EICAR is an industry-standard AV test string, not actual malware. Detection confirms AV is working correctly. No threat. Document and close. Note the user (jsmith) — confirm whether they were running an AV test or if they downloaded it unknowingly (minor user awareness flag).

---

#### Ticket #004 — Scheduled Task Created by Non-Admin Account

> **Alert:** Event ID 4698 — Scheduled task `WindowsUpdateHelper` created by user `contractor_acc1` (non-admin) on SERVER-DB01

**Classification:** ✅ True Positive (TP)  
**Priority:** P1 — Critical  
**Justification:** A non-admin contractor account creating a scheduled task on a database server is highly anomalous (T1053.005). This is a likely persistence mechanism following privilege escalation. Immediate escalation required: isolate SERVER-DB01, revoke contractor account, and investigate how the account gained task-creation rights.

---

#### Ticket #005 — DNS Query to Known-Bad Domain

> **Alert:** DNS query for `update-service-cdn.net` flagged as C2 IOC in threat intel feed, from WORKSTATION-12

**Classification:** ✅ True Positive (TP)  
**Priority:** P2 — High  
**Justification:** DNS query matching a current C2 IOC is a confirmed threat indicator (T1071.004 — Application Layer Protocol: DNS). The host WORKSTATION-12 is likely compromised. Isolate, check for active connections, pull memory if available, and open a formal case.

---

#### Ticket #006 — After-Hours Admin Login

> **Alert:** Successful login by `svc_backup` account at 02:37 AM on a Saturday (Event ID 4624, Logon Type 3)

**Classification:** ⚠️ True Positive (TP) — requires verification  
**Priority:** P3 — Medium  
**Justification:** Service accounts authenticating outside normal backup windows at weekends are anomalous (T1078 — Valid Accounts). Could be legitimate automated backup job. Cross-check backup schedule with sysadmin team before escalating. If not scheduled: escalate to P2.

---

#### Ticket #007 — IT Admin Running Mimikatz String Match

> **Alert:** AV flagged strings matching Mimikatz on IT Admin workstation `ITADMIN-02`, file: `mimikatz_2.2.0.exe`

**Classification:** ✅ True Positive (TP) — verify authorisation  
**Priority:** P3 — Medium  
**Justification:** Even for IT admins, running known credential-dumping tools (T1003) requires formal change management authorisation. Check the change log. If not pre-approved: escalate to P2 and treat as potential insider threat or compromised admin account.

---

#### Ticket #008 — User Reporting Phishing Email

> **Alert:** User `jdoe@company.com` forwarded a suspicious email to the SOC inbox. Email has an invoice attachment (.docm).

**Classification:** ✅ True Positive (TP) — phishing campaign  
**Priority:** P2 — High  
**Justification:** A `.docm` (macro-enabled Word document) sent unsolicited matches phishing delivery (T1566.001). Extract sender metadata, defang and analyse the attachment in a sandbox (e.g., Any.run or local Cuckoo). Block sender domain at email gateway. Check for other recipients of same campaign.

---

## Challenge Scenario — 4-Stage Attack Narrative Solution

> New narrative: **Credential spray → WMI execution → DLL sideloading → data staged to USB**

| Stage | Tactic | Technique | ID |
|-------|--------|-----------|-----|
| Credential spray against O365 | Credential Access | Brute Force: Password Spraying | T1110.003 |
| WMI remote execution | Execution | Windows Management Instrumentation | T1047 |
| DLL sideloading for defence evasion | Defence Evasion | Hijack Execution Flow: DLL Side-Loading | T1574.002 |
| Data staged to removable media | Collection → Exfiltration | Data Staged: Local Data Staging + Exfiltration Over Physical Medium | T1074.001 + T1052.001 |

**Additional 5 Tickets (rapid triage):**

| # | Alert Summary | Classification | Priority | Reason |
|---|---------------|----------------|----------|--------|
| T9 | 200 login attempts against `admin@company.com` via O365 | TP | P2 | Password spray — matches T1110.003 |
| T10 | WMI process launch from remote host to FILESERVER-01 | TP | P1 | Unusual WMI lateral use — T1047 |
| T11 | Legit signed app loading unexpected DLL from user-writable path | TP | P2 | DLL sideloading indicator — T1574.002 |
| T12 | Large file copy to USB drive by HR user during work hours | BP | P3 | Potentially legitimate; verify with HR manager |
| T13 | IT scanner running Nmap on internal /16 subnet | BP | P4 | Confirmed IT asset scan — authorised change ticket found |

---

[⬅ Setup](./setup.md) | [Grading Rubric ➡](./grading-rubric.md)
