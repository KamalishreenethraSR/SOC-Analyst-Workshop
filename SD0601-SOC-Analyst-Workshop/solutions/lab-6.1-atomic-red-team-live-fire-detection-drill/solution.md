# Lab 6.1 — Solution: Atomic Red Team Live-Fire Detection Drill

**Module:** [Module 6 — SOC Operations and Practical Labs](../../docs/06-soc-operations-and-practical-labs-incl-capstone.md)

---

## Step 1 — Confirm Full Monitoring Stack is Active

```bash
# Docker host health check
docker compose ps
# All: elasticsearch, kibana, wazuh-manager, thehive → healthy/running

# Windows VM
Get-Service Sysmon64, winlogbeat, WazuhSvc | Select-Object Status, Name
# All three: Running

# Linux VM
systemctl is-active filebeat wazuh-agent
# Both: active
```

**Expected Wazuh Dashboard:** Windows victim VM shows "Active" status, recent events visible.

---

## Step 2 — Attacker: Run Atomic Test T1110 (Brute Force)

**Attacker/Operator role — Administrator PowerShell on victim VM:**

```powershell
# Show test details first
Invoke-AtomicTest T1110 -TestNumbers 1 -ShowDetails

# Execute the test
Invoke-AtomicTest T1110 -TestNumbers 1
```

**What this does:**
- Generates multiple failed authentication attempts (Event ID 4625)
- Simulates password guessing / brute force (T1110.001)
- Should trigger within 30–60 seconds in Wazuh/Kibana

**Expected console output:**
```
PathToAtomicsFolder: C:\AtomicRedTeam\atomics
Executing test: T1110-1 Create a list of passwords to attempt brute forcing...
...
Done executing test: T1110-1 Create a list of passwords to attempt brute forcing...
```

---

## Step 3 — Defender: Detect T1110 (within 5-minute SLA)

**Timeline starts the moment the attacker runs the test.**

**Kibana — open Discover (winlogbeat-* or filebeat-*):**
```kql
event.code:4625 AND event.outcome:failure
```
Filter: Last 15 minutes, auto-refresh 10s

**Wazuh Dashboard → Security events:**
```
Search: rule.id:18152 OR rule.id:5710
```
> Rule 18152 = Windows logon failure; 5710 = Multiple authentication failures

**Expected Wazuh Alert:**
```
Rule: Multiple authentication failures (5710)
Severity: 12 (High)
Description: Multiple authentication failures from 10.10.1.45
Count: 10 failures in 60 seconds
Timestamp: 2024-08-14T16:30:22
```

**Defender Actions:**
1. Note detection timestamp
2. Open TheHive → **Create Case:**
   - Title: `ART T1110 — Brute Force Detected — VICTIMWIN10`
   - Severity: High
   - Tags: `T1110.001`, `brute-force`, `lab-6.1`
3. Add observable: source IP attempting logins
4. Classification: **True Positive**
5. Note escalation time vs detection time

---

## Step 4 — Attacker: Run T1053 then T1059 in Sequence

```powershell
# T1053 — Scheduled Task creation
Invoke-AtomicTest T1053.005 -TestNumbers 1
Start-Sleep -Seconds 30

# T1059 — PowerShell execution
Invoke-AtomicTest T1059.001 -TestNumbers 1
```

**Expected Events Generated:**
| Test | Event ID | Wazuh Rule | Description |
|------|---------|-----------|-------------|
| T1053.005 | 4698 | 18145 | Scheduled task created |
| T1059.001 | Sysmon 1 | 92007 | PowerShell spawned with suspicious flags |

---

## Step 5 — Defender: Correlate as Single Incident

**Key insight:** T1053 (persistence) followed immediately by T1059 (execution) = one attack chain, not two separate incidents.

**Detection in Kibana:**
```kql
event.code:(4698 OR 1) AND (process.name:powershell.exe OR winlog.event_data.TaskName:*)
```

**Correlation Decision:**
```
Analyst Note: Two alerts within 30 seconds on the same host (VICTIMWIN10)
  Alert 1: Scheduled task created (T1053.005) at 16:32:05
  Alert 2: PowerShell launched (T1059.001) at 16:32:38

DECISION: These are part of the same attack chain.
          Correlate into ONE incident in TheHive:
          "ART T1053+T1059 Persistence + Execution Chain — VICTIMWIN10"

Add both observables to the single case.
Escalation reason: Two-stage persistence + execution = elevated threat.
```

**Escalation Matrix Application:**
```
Severity assessment:
  - Confirmed TP: YES (ART test known + events confirmed)
  - Asset criticality: Medium (lab VM)
  - Spreading: No (isolated lab environment)
  - Priority: P2 — High

Escalation action:
  - Notify SOC Tier 2 within SLA (escalation time recorded)
  - Document containment: isolate host (lab: simulate by noting action)
```

---

## Step 6 — Incident Timeline

```
INCIDENT TIMELINE — Pair Session 1
====================================
Date:          2024-08-14
Attacker:      Student A
Defender:      Student B

TIME          EVENT
──────────────────────────────────────────────────────────────────
16:28:00      Lab start — monitoring stack confirmed active

T1110 PHASE
16:30:00      [ATK] Invoke-AtomicTest T1110 -TestNumbers 1 executed
16:30:42      [DEF] WAZUH alert fired: rule 5710 (multiple auth failures)
16:31:15      [DEF] Kibana: event.code:4625, source 10.10.1.45, 10+ failures
16:31:45      [DEF] TheHive case created: ART T1110
16:32:00      [DEF] Case classified: TP, Priority P2
              Detection time:    42 seconds ✅ (SLA: 5 min)
              Triage time:       1 min 15 sec
              Escalation time:   2 minutes from detection

T1053 + T1059 PHASE
16:40:00      [ATK] Invoke-AtomicTest T1053.005 -TestNumbers 1 executed
16:40:12      [ATK] Invoke-AtomicTest T1059.001 -TestNumbers 1 executed
16:40:55      [DEF] Wazuh rule 18145 fired: scheduled task created (4698)
16:41:08      [DEF] Sysmon Event ID 1: powershell.exe with -EncodedCommand
16:41:30      [DEF] CORRELATION DECISION: same incident chain
16:42:00      [DEF] TheHive case: "T1053+T1059 Persistence+Execution Chain"
16:43:00      [DEF] Escalated to Tier 2 (simulated)
              Detection time:    55 seconds ✅ (SLA: 5 min)
              Triage time:       2 minutes
              Total T-to-Containment (simulated): 13 minutes

──────────────────────────────────────────────────────────────────
SUMMARY
  Tests executed:           2 (T1110, T1053+T1059)
  Tests detected:           2/2 (100%)
  SLA met (5 min detect):   2/2 ✅
  TheHive cases opened:     2
  Correct correlations:     1 (T1053+T1059 merged into 1 case)
```

---

## Step 7 — Roles Swapped: Repeat with New Tests

**Instructor selects two new Atomic tests, e.g.:**
- `T1003.001` — LSASS Credential Dumping
- `T1027` — Obfuscated Files or Information

**New Attacker (Student B) runs:**
```powershell
Invoke-AtomicTest T1003.001 -TestNumbers 1
Invoke-AtomicTest T1027 -TestNumbers 1
```

**New Defender (Student A) follows the same detection workflow.**

---

## Lab Challenge — Solo Defender Solution

```
Solo challenge setup:
  - Instructor announces go-ahead
  - Two Atomic tests run back-to-back without announcement

Detection workflow for solo analyst:
  1. Kibana auto-refresh (10s) on winlogbeat-* + zeek-* dashboards
  2. Wazuh security events (real-time)
  3. For EACH alert:
     a. Classify TP/FP (confidence + evidence)
     b. Open TheHive case immediately
     c. Add observable(s)
     d. Escalate with escalation note and timestamp
  
Time discipline:
  - 15-minute COMBINED SLA for both detections
  - Allocate max 7 minutes per test
  - If first detection + triage > 7 min, second test is at risk

Evidence for grading:
  - Two TheHive cases with correct ATT&CK technique tags
  - Timestamps proving < 15 min from attack start to second escalation
```

---

[⬅ Setup](./setup.md) | [Grading Rubric ➡](./grading-rubric.md)
