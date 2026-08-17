# Mock SOC Ticket Queue — Lab 1.1

> **Instructor Note:** These 8 tickets represent a realistic SOC queue with mixed severity and classification. Load these into TheHive/osTicket demo instance, or distribute as this markdown document. Students should complete the Classification and Priority columns and write their justification in the Notes field.

---

## Ticket Queue

| ID | Ticket Title | Source System | Time | Student Classification | Student Priority | Student Notes |
|----|-------------|---------------|------|----------------------|-----------------|---------------|
| #001 | Suspicious PowerShell Execution from WinWord | EDR / Sysmon | 14:32 | | | |
| #002 | Failed Login Burst — 47 attempts in 4 min | SIEM / Windows Security | 02:17 | | | |
| #003 | AV Detection — EICAR Test File | Antivirus (Defender) | 09:55 | | | |
| #004 | Non-Admin Account Created Scheduled Task on DB Server | SIEM / Windows Security | 03:44 | | | |
| #005 | DNS Query to Known C2 Domain | DNS / Threat Intel Feed | 11:22 | | | |
| #006 | After-Hours Login — Service Account (02:37 Saturday) | SIEM / Windows Security | 02:37 | | | |
| #007 | Mimikatz Binary Detected on IT Admin Workstation | AV / EDR | 16:08 | | | |
| #008 | User-Reported Phishing Email with .docm Attachment | Email Gateway / User Report | 10:14 | | | |

---

## Ticket Details

---

### Ticket #001 — Suspicious PowerShell Execution from WinWord

**Source:** Sysmon Event ID 1 (Process Creation) + EDR Alert  
**Host:** WORKSTATION-07 (jsmith)  
**Time:** 14:32 UTC  
**Severity (SIEM):** High  

**Raw Alert Detail:**
```
ParentImage:  C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE
Image:        C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
CommandLine:  powershell.exe -ExecutionPolicy Bypass -EncodedCommand <base64_string>
User:         CORP\jsmith
TargetObject: WORKSTATION-07
```

**Classification:** `[ ] TP  [ ] FP  [ ] BP`  
**Priority:** `[ ] P1  [ ] P2  [ ] P3  [ ] P4`  
**Notes (Justification):**

---

### Ticket #002 — Failed Login Burst

**Source:** Windows Security Event ID 4625  
**Host:** Targeting `ADMIN` account across multiple hosts  
**Time:** 02:17 UTC  
**Severity (SIEM):** High  

**Raw Alert Detail:**
```
EventID:      4625
TargetUserName: admin
LogonType:    3 (Network)
SourceAddress: 10.10.5.22
Count:        47 failures in 4 minutes (02:13 – 02:17 UTC)
```

**Classification:** `[ ] TP  [ ] FP  [ ] BP`  
**Priority:** `[ ] P1  [ ] P2  [ ] P3  [ ] P4`  
**Notes (Justification):**

---

### Ticket #003 — AV Detection: EICAR Test File

**Source:** Windows Defender / Endpoint AV  
**Host:** WORKSTATION-09 (jsmith downloads folder)  
**Time:** 09:55 UTC  
**Severity (SIEM):** Low  

**Raw Alert Detail:**
```
ThreatName:   Virus:DOS/EICAR_Test_File
FilePath:     C:\Users\jsmith\Downloads\eicar.com
Action:       Quarantined
SHA256:       275a021bbfb6489e54d471899f7db9d1663fc695ec2fe2a2c4538aabf651fd0f
```

**Classification:** `[ ] TP  [ ] FP  [ ] BP`  
**Priority:** `[ ] P1  [ ] P2  [ ] P3  [ ] P4`  
**Notes (Justification):**

---

### Ticket #004 — Non-Admin Scheduled Task on Database Server

**Source:** Windows Security Event ID 4698  
**Host:** SERVER-DB01  
**Time:** 03:44 UTC  
**Severity (SIEM):** Critical  

**Raw Alert Detail:**
```
EventID:      4698
TaskName:     \Microsoft\Windows\WindowsUpdateHelper
Author:       CORP\contractor_acc1
HostTarget:   SERVER-DB01
Action:       C:\Windows\Temp\helper.exe
Trigger:      AtLogon
```

**Classification:** `[ ] TP  [ ] FP  [ ] BP`  
**Priority:** `[ ] P1  [ ] P2  [ ] P3  [ ] P4`  
**Notes (Justification):**

---

### Ticket #005 — DNS Query to Known C2 Domain

**Source:** DNS Server Logs + Threat Intel Feed (block list match)  
**Host:** WORKSTATION-12 (bwilliams)  
**Time:** 11:22 UTC  
**Severity (SIEM):** High  

**Raw Alert Detail:**
```
QueryName:    update-service-cdn.net
QueryType:    A
Source:       WORKSTATION-12 (10.10.1.45)
TI Match:     Known C2 domain — VirusTotal 34/92 detections
TI Tags:      [emotet, c2, malware]
```

**Classification:** `[ ] TP  [ ] FP  [ ] BP`  
**Priority:** `[ ] P1  [ ] P2  [ ] P3  [ ] P4`  
**Notes (Justification):**

---

### Ticket #006 — After-Hours Service Account Login

**Source:** Windows Security Event ID 4624  
**Host:** FILE-SERVER-01  
**Time:** 02:37 UTC (Saturday)  
**Severity (SIEM):** Medium  

**Raw Alert Detail:**
```
EventID:      4624
AccountName:  svc_backup
LogonType:    3 (Network)
SourceAddress: 10.10.0.15
Day:          Saturday
Time:         02:37 UTC
LogonCount:   1 (not repeated)
```

**Classification:** `[ ] TP  [ ] FP  [ ] BP`  
**Priority:** `[ ] P1  [ ] P2  [ ] P3  [ ] P4`  
**Notes (Justification):**

---

### Ticket #007 — Mimikatz Detected on IT Admin Workstation

**Source:** Windows Defender + EDR  
**Host:** ITADMIN-02 (it_admin_rlee)  
**Time:** 16:08 UTC  
**Severity (SIEM):** High  

**Raw Alert Detail:**
```
ThreatName:   HackTool:Win32/Mimikatz
FilePath:     C:\Users\rlee\Desktop\Tools\mimikatz_2.2.0.exe
SHA256:       6acaf8cccde3fd9c5c83b6c22e0c8c0b8a3f8e31d5f4f9c7e8b3d6c9e5a2b1d
Action:       Blocked (real-time protection)
User:         CORP\it_admin_rlee
```

**Classification:** `[ ] TP  [ ] FP  [ ] BP`  
**Priority:** `[ ] P1  [ ] P2  [ ] P3  [ ] P4`  
**Notes (Justification):**

---

### Ticket #008 — User-Reported Phishing Email

**Source:** User Report + Email Gateway  
**Reported By:** jdoe@company.com  
**Time:** 10:14 UTC  
**Severity (SIEM):** N/A (user-reported)  

**Raw Alert Detail:**
```
From:         accounting-invoices@ledger-secure-update.com
Subject:      URGENT: Invoice #INV-20240814 — Action Required
Attachment:   Invoice_August2024.docm  (SHA256: d4e9f2...)
BodyLinks:    http://185.220.101.55/payload.zip
Sent To:      jdoe@company.com (and 6 others in Finance team)
```

**Classification:** `[ ] TP  [ ] FP  [ ] BP`  
**Priority:** `[ ] P1  [ ] P2  [ ] P3  [ ] P4`  
**Notes (Justification):**

---

## Classification Reference

| Term | Definition |
|------|-----------|
| **True Positive (TP)** | The alert correctly identifies a real threat or malicious activity |
| **False Positive (FP)** | The alert fired but the activity is legitimate — no threat present |
| **Benign-Positive (BP)** | The alert fired on real activity that is intentional and safe (e.g., AV test, authorised pen test) |

## Priority Reference

| Priority | Meaning | Example |
|----------|---------|---------|
| P1 — Critical | Active/confirmed breach or imminent risk; immediate action required | Confirmed ransomware encrypting shares |
| P2 — High | Confirmed or highly likely TP; investigate this shift | C2 DNS hit on workstation |
| P3 — Medium | Possible TP, needs verification; investigate within 4h | After-hours service account login |
| P4 — Low | BP or FP; document and close | EICAR AV test detection |
