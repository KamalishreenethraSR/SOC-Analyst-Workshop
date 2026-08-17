# Lab 5.1 — Grading Rubric: Endpoint Detection, Threat Hunt, and Memory Triage

**Total Points: 100**

---

## Part 1 — Wazuh Agent Enrolment (10 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| Wazuh agent installed and reporting from Windows VM | 5 | Agent shows "Active" in Wazuh Dashboard → Agents tab |
| Agent reports events correctly (Sysmon + Security logs) | 5 | Recent events visible in Wazuh Dashboard for that agent |

---

## Part 2 — Simulated Attack Detection (25 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| Event 4720 (new user created) detected in Wazuh within 10 min | 8 | Wazuh alert with rule.id 18154; timestamp recorded |
| Event 4732 (user added to Administrators) detected | 5 | Wazuh alert for group membership change |
| Event 4698 (scheduled task created) detected in Wazuh | 7 | Wazuh alert with rule.id 18145; task name recorded |
| All raw event details documented (user name, task name, timestamp) | 5 | Full event details in student notes, not just alert summary |

---

## Part 3 — auditd Linux Monitoring (15 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| `auditctl` watch rule applied to `/etc/passwd` with correct flags (`-p wa -k`) | 5 | `auditctl -l` output shows the rule |
| Change to `/etc/passwd` is triggered | 3 | Command used to modify the file is documented |
| `ausearch -k passwd_watch` returns the audit event | 7 | ausearch output showing syscall, auid, exe fields |

---

## Part 4 — Threat Hunt (25 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| Hunt hypothesis written in structured format (If → Expect) | 5 | Documented hypothesis referencing MITRE ATT&CK |
| Query/method documented (KQL, PowerShell, or Wazuh filter) | 5 | Actual query/command shown |
| Findings documented (finding OR documented null result) | 8 | Parent-child relationship confirmed OR null result with explanation |
| MITRE ATT&CK technique correctly identified | 4 | T1566 → T1059 or equivalent parent-child chain |
| Time window and scope recorded | 3 | Date range, hostname, analyst name in documentation |

---

## Part 5 — Volatility3 Memory Triage (25 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| `windows.pslist` run and output captured | 4 | Full process list documented |
| `windows.pstree` used to identify suspicious parent-child chain | 5 | Suspicious process identified with PID and PPID |
| `windows.netscan` run and output captured | 4 | Network connections table shown |
| Suspicious process correlated with external network connection | 7 | Process name + external IP + port documented as one finding |
| Mini forensic note written (4 required fields) | 5 | Process name/PID, parent process, network indicator, recommended next step |

---

## Lab Challenge Bonus (10 bonus points)

| Criterion | Points |
|-----------|--------|
| Second memory image analysed: malicious process identified with name + PID | 4 |
| Parent process of malicious process documented | 2 |
| Associated network connection found (IP + port) | 2 |
| MITRE ATT&CK technique correctly stated | 2 |

---

## Scoring Bands

| Score | Band |
|-------|------|
| 90–100 | Distinction |
| 75–89 | Merit |
| 60–74 | Pass |
| < 60 | Requires Re-sit |

---

## Instructor Notes

- **Detection within 10 minutes:** Accept up to 12 minutes if student can demonstrate the event was present and they found it; deduct 2 points if found between 10–12 minutes.
- **Null result in hunt:** Full credit for documenting a genuine null result with "no evidence found in this time window" — this is realistic and valid.
- **Volatility output format:** Accept any correct output format; the student doesn't need to parse it into a table as long as the key fields are identified.

---

[⬅ Solution](./solution.md) | [⬅ Back to Solutions Index](../README.md)
