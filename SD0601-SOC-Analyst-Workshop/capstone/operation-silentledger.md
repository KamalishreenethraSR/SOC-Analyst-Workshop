# Capstone Project — Operation SilentLedger

[⬅ Back to README](../README.md) | [Module 6](../docs/06-soc-operations-and-practical-labs-incl-capstone.md)

## Premise

Ledgerlyne Financial, a mid-size fintech processing payment settlements, has suffered a suspected breach. The SOC team (each student, or in pairs) is handed a forensic evidence package — pre-captured Sysmon/Windows Security EVTX logs, Zeek network logs, a phishing email, a suspicious binary hash, and a partial memory image — covering roughly a 6-hour attack window. There is no live attacker; all evidence is pre-staged by the instructor to represent a completed multi-stage breach.

## Multi-Stage Breach Narrative

### Stage 1 — Initial Access

A finance-team employee received a phishing email with a malicious invoice attachment (T1566.001). Evidence: the .eml file and an EVTX excerpt showing a Word process spawning PowerShell.

### Stage 2 — Execution & Persistence

The PowerShell payload downloaded a second-stage tool and created a scheduled task for persistence (T1059.001, T1053.005). Evidence: Sysmon process-creation and scheduled-task-creation events.

### Stage 3 — Credential Access & Privilege Escalation

The attacker dumped local credentials and created a new local administrator account (T1003, T1136). Evidence: Event IDs 4720/4732 and a memory-image artifact.

### Stage 4 — Lateral Movement

Using the new admin credentials, the attacker moved laterally to a finance database server via RDP (T1021.001). Evidence: Zeek conn.log showing internal RDP (port 3389) traffic between two unusual host pairs.

### Stage 5 — Collection & Exfiltration

Sensitive settlement data was staged and exfiltrated to an external IP over HTTPS, exhibiting a beaconing pattern beforehand (T1074, T1041, T1071). Evidence: Zeek conn.log showing regular short connections to an external IP followed by one large outbound transfer.

## Deliverables

- A complete attack timeline reconstructed from the evidence, with timestamps for each of the 5 stages
- A MITRE ATT&CK Navigator layer showing every technique observed across the kill chain
- A full IOC list (hashes, IPs, domains, account names) entered into MISP with correct typing
- A TheHive case documenting the incident through all 4 NIST SP 800-61 phases, including concrete containment/eradication/recovery recommendations for Ledgerlyne Financial
- A 2-page technical incident report (audience: SOC Manager/L3)
- A 1-page executive summary (audience: CISO/Board) — plain language, business impact, and remediation cost/priority framing, no jargon
- A 10-minute mock stakeholder presentation walking through the breach narrative and recommendations
