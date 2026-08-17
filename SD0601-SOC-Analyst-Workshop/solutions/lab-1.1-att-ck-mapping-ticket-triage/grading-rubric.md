# Lab 1.1 — Grading Rubric: ATT&CK Mapping & Ticket Triage

**Total Points: 100**

---

## Part 1 — ATT&CK Navigator Mapping (50 points)

| Criterion | Points | Notes |
|-----------|--------|-------|
| Navigator layer created with correct student naming convention (`Lab1-<StudentID>`) | 5 | Check layer name in exported JSON |
| Minimum 5 distinct techniques highlighted | 10 | Deduct 2pts per missing technique below 5 |
| All 6 core techniques from the attack narrative mapped | 15 | T1566.001, T1059.001, T1105, T1053.005, T1003, T1021.001 — 2.5pts each |
| Correct Tactic assignment for each highlighted technique | 10 | Tactic must match the technique (e.g., T1021.001 under Lateral Movement) |
| Layer exported as valid JSON and submitted | 10 | Must be parseable; open in Navigator to verify |

### Technique Mapping Key

| Technique ID | Tactic | Full Credit Answer |
|---|---|---|
| T1566.001 | Initial Access (TA0001) | Phishing: Spearphishing Attachment |
| T1204.002 or T1059.001 | Execution (TA0002) | User Execution OR PowerShell (accept either for macro stage) |
| T1105 | Command & Control (TA0011) | Ingress Tool Transfer |
| T1053.005 | Persistence (TA0003) | Scheduled Task/Job: Scheduled Task |
| T1003 | Credential Access (TA0006) | OS Credential Dumping (any sub-technique accepted) |
| T1021.001 | Lateral Movement (TA0008) | Remote Services: RDP |

---

## Part 2 — Ticket Triage (50 points)

**6.25 points per ticket** (8 tickets × 6.25 = 50)

### Per-Ticket Scoring

| Sub-criterion | Points |
|---|---|
| Correct TP/FP/BP classification | 2.5 |
| Correct P1–P4 priority | 2.0 |
| Written justification references observable evidence | 1.75 |

### Answer Key

| Ticket | Classification | Priority |
|--------|---------------|---------|
| #001 — Suspicious PowerShell from WinWord | TP | P2 |
| #002 — 47 failed logins in 4 min | TP | P2 |
| #003 — EICAR AV detection | BP | P4 |
| #004 — Non-admin scheduled task on DB server | TP | P1 |
| #005 — DNS query to C2 IOC | TP | P2 |
| #006 — After-hours service account login | TP (verify) | P3 |
| #007 — Mimikatz on IT admin workstation | TP (verify auth) | P3 |
| #008 — User-reported phishing .docm | TP | P2 |

### Grading Notes for Instructors

- **Ticket #006:** Accept P2 or P3 — both are defensible if the student explains the need to verify the backup schedule first.
- **Ticket #007:** Accept P2 or P3 — P2 if student flags it as potential insider threat; P3 if student correctly says to verify change management first.
- **Justification:** Must reference at least one observable (Event ID, count, file type, account name, etc.) — not just "it looks suspicious."

---

## Challenge Scenario Bonus (10 bonus points)

| Criterion | Points |
|---|---|
| All 4 new techniques correctly mapped with IDs | 4 |
| 5 additional tickets triaged correctly (within 30 min) | 4 |
| Timer met (evidence: lab start/submit timestamp) | 2 |

---

## Scoring Bands

| Score | Band |
|-------|------|
| 90–100 | Distinction |
| 75–89 | Merit |
| 60–74 | Pass |
| < 60 | Requires Re-sit |

---

[⬅ Solution](./solution.md) | [⬅ Back to Solutions Index](../README.md)
