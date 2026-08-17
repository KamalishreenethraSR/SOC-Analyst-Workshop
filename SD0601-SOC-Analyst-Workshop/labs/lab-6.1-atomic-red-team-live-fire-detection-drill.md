# Lab 6.1 — Atomic Red Team Live-Fire Detection Drill

**Module:** [Module 6 — SOC Operations and Practical Labs (incl. Capstone)](../docs/06-soc-operations-and-practical-labs-incl-capstone.md)

## Scenario

Working in pairs (one 'attacker/automation operator', one 'defender/analyst', roles swapped halfway), students run controlled Atomic Red Team tests against the monitored lab environment built across Modules 2–5 and must detect, triage, and escalate each in real time.

## Step-by-Step

1. Confirm the full monitoring stack (Sysmon/Winlogbeat/Filebeat → Elasticsearch/Splunk, Wazuh agent) is active on the target VM.
2. Attacker operator runs Atomic Test T1110 (Brute Force): Invoke-AtomicTest T1110 -TestNumbers 1.
3. Defender analyst must detect the alert in the SIEM/Wazuh dashboard within a 5-minute SLA, open a case in TheHive, and classify it correctly.
4. Attacker operator runs Atomic Test T1053 (Scheduled Task/Job) and T1059 (Command and Scripting Interpreter) in sequence.
5. Defender must correlate the two events as a single incident (not two separate alerts), escalate per the Day-1 Escalation Matrix, and document escalation time against the SLA.
6. Swap roles and repeat with two new Atomic tests chosen by the instructor.
7. Each pair produces a short incident timeline showing: detection time, triage time, escalation time, and total time-to-containment (simulated).

## Expected Outcomes

- At least 4 Atomic Red Team tests executed and detected
- TheHive cases opened, correctly triaged, and escalated within SLA for each
- An incident timeline documenting detection/triage/escalation/containment timestamps

## Hands-on Lab Challenge

As the sole defender, detect, correctly triage, and escalate 2 back-to-back unannounced Atomic Red Team tests within a combined 15-minute SLA, with a fully documented TheHive case for each.



