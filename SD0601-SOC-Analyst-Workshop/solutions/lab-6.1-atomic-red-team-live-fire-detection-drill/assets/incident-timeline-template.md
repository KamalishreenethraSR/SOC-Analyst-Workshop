# Incident Timeline — Lab 6.1: Atomic Red Team Live-Fire Detection Drill

**Instructions:** Fill in each cell as events occur. Record all times in `HH:MM:SS` (24h) format.  
Times are relative to lab session start. Timestamps are entered by the **Defender** role.

---

## Session Info

| Field | Value |
|-------|-------|
| Date | |
| Attacker (Round 1) | |
| Defender (Round 1) | |
| Attacker (Round 2) | |
| Defender (Round 2) | |
| Lab Start Time | HH:MM:SS |

---

## Round 1 — Incident Timeline

### Test 1: T1110 — Brute Force

| Milestone | Timestamp (HH:MM:SS) | Elapsed from Attack | Notes |
|-----------|---------------------|---------------------|-------|
| Attack executed by operator | | 00:00:00 | Operator records this time |
| Alert first seen in SIEM/Wazuh | | | Detection time |
| Alert triaged (TP/FP decision made) | | | Triage time |
| TheHive case created | | | Case # |
| Escalated to Tier 2 (simulated) | | | Escalation time |

**SLA Check:**
- Detection SLA (≤ 5:00): `[ ] MET  [ ] MISSED` — Actual: ___:___
- Escalation SLA (≤ 10:00 from attack): `[ ] MET  [ ] MISSED` — Actual: ___:___

**TheHive Case #:** _________________  
**Classification:** `[ ] TP  [ ] FP  [ ] BP`  
**MITRE Technique:** _________________

---

### Tests 2 & 3: T1053.005 + T1059.001 — Scheduled Task + PowerShell (Correlated)

| Milestone | Timestamp (HH:MM:SS) | Elapsed from First Attack | Notes |
|-----------|---------------------|--------------------------|-------|
| T1053.005 executed by operator | | 00:00:00 | |
| T1059.001 executed by operator | | | ~30s after T1053 |
| T1053 alert seen in SIEM/Wazuh | | | |
| T1059 alert seen in SIEM/Wazuh | | | |
| Correlation decision made | | | "Single incident" or "Two incidents" |
| TheHive case(s) created | | | Case #(s) |
| Escalated to Tier 2 (simulated) | | | |

**SLA Check (per test):**
- T1053 Detection SLA (≤ 5:00): `[ ] MET  [ ] MISSED` — Actual: ___:___
- T1059 Detection SLA (≤ 5:00): `[ ] MET  [ ] MISSED` — Actual: ___:___

**Correlation decision:** `[ ] Correlated as 1 case  [ ] Two separate cases`  
**Justification for correlation decision:**
> _(Student writes here)_

---

## Round 2 — Roles Swapped

### Test 4: (Instructor-chosen test) — _______________

| Milestone | Timestamp (HH:MM:SS) | Elapsed from Attack | Notes |
|-----------|---------------------|---------------------|-------|
| Attack executed by operator | | 00:00:00 | |
| Alert first seen in SIEM/Wazuh | | | Detection time |
| Alert triaged | | | |
| TheHive case created | | | Case # |
| Escalated to Tier 2 (simulated) | | | |

**SLA Check:**
- Detection SLA (≤ 5:00): `[ ] MET  [ ] MISSED` — Actual: ___:___

**TheHive Case #:** _________________  
**MITRE Technique:** _________________

---

### Test 5: (Instructor-chosen test) — _______________

| Milestone | Timestamp (HH:MM:SS) | Elapsed from Attack | Notes |
|-----------|---------------------|---------------------|-------|
| Attack executed by operator | | 00:00:00 | |
| Alert first seen in SIEM/Wazuh | | | Detection time |
| Alert triaged | | | |
| TheHive case created | | | Case # |
| Escalated to Tier 2 (simulated) | | | |

**SLA Check:**
- Detection SLA (≤ 5:00): `[ ] MET  [ ] MISSED` — Actual: ___:___

**TheHive Case #:** _________________  
**MITRE Technique:** _________________

---

## Summary Table

| Test | Technique | Detected? | Detection Time | SLA Met? | Escalated? | TheHive Case # |
|------|-----------|-----------|---------------|---------|-----------|--------------|
| 1 — T1110 | Brute Force | `[ ]Y [ ]N` | ___:___ | `[ ]Y [ ]N` | `[ ]Y [ ]N` | |
| 2 — T1053.005 | Scheduled Task | `[ ]Y [ ]N` | ___:___ | `[ ]Y [ ]N` | `[ ]Y [ ]N` | |
| 3 — T1059.001 | PowerShell | `[ ]Y [ ]N` | ___:___ | `[ ]Y [ ]N` | `[ ]Y [ ]N` | |
| 4 — ___________ | ___________ | `[ ]Y [ ]N` | ___:___ | `[ ]Y [ ]N` | `[ ]Y [ ]N` | |
| 5 — ___________ | ___________ | `[ ]Y [ ]N` | ___:___ | `[ ]Y [ ]N` | `[ ]Y [ ]N` | |

---

## Key Metrics (auto-calculate from table above)

| Metric | Value |
|--------|-------|
| Total tests executed | |
| Total tests detected | / |
| Detection rate | % |
| SLA met count | / |
| Average detection time | HH:MM:SS |
| Total time (lab start → last escalation) | HH:MM:SS |

---

## Lessons Learned

_What would you tune, change, or improve in the monitoring stack based on this drill?_

1. 
2. 
3. 

---

## Defender Notes / Observations

_Free text for anything not captured in the table above._

> _(Write here)_

---

*Template: SD0601 SOC Analyst Workshop — Lab 6.1*
