# Lab 6.1 — Grading Rubric: Atomic Red Team Live-Fire Detection Drill

**Total Points: 100**

---

## Part 1 — Pre-Lab Stack Verification (10 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| Full monitoring stack confirmed healthy before drill starts | 5 | Health check output showing all services green (elastic, kibana, wazuh, thehive) |
| Atomic Red Team installed and `Invoke-AtomicTest` returns test details | 5 | `Invoke-AtomicTest T1059 -ShowDetails` output shown or screenshot |

---

## Part 2 — Round 1 Detection (Defender) (35 points)

### T1110 — Brute Force

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| Alert detected in SIEM/Wazuh within 5-minute SLA | 10 | Detection timestamp documented; SLA: ≤ 5 minutes from attack execution |
| TheHive case created with correct title, severity, and TLP | 5 | Case visible in TheHive; title references T1110 or "Brute Force" |
| Correct classification as True Positive | 3 | Case status or note records TP |
| Alert correctly identified as T1110.001 | 2 | Technique ID in case notes or tags |

### T1053.005 + T1059.001 — Correlation

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| Both alerts detected within 5-minute SLA each | 8 | Two detection timestamps documented |
| Correctly correlated as a SINGLE incident (not two separate cases) | 5 | One TheHive case containing both observables with correlation note |
| Escalation documented with timestamp | 2 | Escalation timestamp in case timeline |

---

## Part 3 — Round 2 Detection (Role Swapped) (35 points)

*Assessed identically to Round 1 but with different tests chosen by instructor.*

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| At least one new Atomic test detected within SLA | 15 | Detection timestamp; SLA ≤ 5 minutes |
| Second test detected within SLA | 10 | Detection timestamp; SLA ≤ 5 minutes |
| TheHive case(s) opened for each detected test | 7 | Cases visible with correct content |
| Escalation completed within SLA | 3 | Escalation note and timestamp |

---

## Part 4 — Incident Timeline Document (20 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| Timeline covers all 4 Atomic tests executed (at least 4 entries) | 5 | Each test appears as an event in the timeline |
| Detection time recorded for each test | 4 | Timestamps in HH:MM:SS format from attack launch to alert seen |
| Triage time recorded (detection → case opened) | 4 | Timestamps show case opened after detection |
| Escalation time recorded (case opened → escalated) | 4 | Escalation timestamp in timeline |
| Total time-to-containment (simulated) calculated | 3 | Total duration from first test to final escalation shown |

---

## SLA Reference

| SLA Target | Metric |
|-----------|--------|
| Detection SLA | ≤ 5 minutes from attack execution |
| Case-open SLA | ≤ 2 minutes from detection |
| Escalation SLA | ≤ 5 minutes from case open |
| Total time-to-containment | ≤ 15 minutes per pair of tests |

---

## Lab Challenge Bonus (10 bonus points)

| Criterion | Points |
|-----------|--------|
| Solo defender detects 2 unannounced tests within combined 15-minute SLA | 5 |
| Two separate, fully documented TheHive cases (one per test) | 3 |
| Both techniques correctly identified with MITRE ATT&CK IDs | 2 |

---

## Instructor Notes

- **SLA grace:** Accept up to 6 minutes if the student detected the alert but was writing up the TheHive case simultaneously — document the discrepancy.
- **Missed alert:** If one test is not detected, the student does not automatically fail — document which test was missed and why (false negative, rule gap, etc.). Deduct points for that section only.
- **Correlation:** The most common failure is creating two separate cases for T1053 + T1059 instead of correlating them. Award 3 of the 5 correlation points if the student identifies both alerts as related in their notes, even if they are in separate cases.
- **Timeline format:** Accept any clear format (table, bullet list, Markdown, text) — the data is what matters.

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
