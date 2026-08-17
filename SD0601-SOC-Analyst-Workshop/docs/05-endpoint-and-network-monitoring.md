# Module 5 — Endpoint and Network Monitoring

**Schedule:** Day 4, Full Day (09:00–21:00)  
**Total:** 12h &nbsp;(Lecture: 4h · Hands-on Lab: 8h)

[⬅ Back to README](../README.md) | [Lab Guide ➡](../labs/lab-5.1-endpoint-detection-threat-hunt-and-memory-triage.md)

## 1. Hourly Breakdown

| Time Block | Format | Topic |
| --- | --- | --- |
| 09:00–09:45 | Lecture | EDR concepts: telemetry, process trees, behavioral detection |
| 09:45–10:30 | Lecture | Windows Event Log deep dive (4624/4625/4688/4672/4720/4732) + auditd on Linux |
| 10:30–10:45 | Break | — |
| 10:45–11:30 | Lecture | UEBA fundamentals: baselining, anomaly scoring, insider-threat indicators |
| 11:30–13:00 | Hands-on Lab | Deploy Wazuh agent; detect simulated privilege escalation |
| 14:00–14:45 | Lecture | Threat hunting fundamentals: hypothesis-driven hunting mapped to ATT&CK |
| 14:45–18:00 | Hands-on Lab | Proactive hunt: suspicious parent-child process relationships |
| 19:00–21:00 | Hands-on Lab | Basic digital forensics: memory triage with Volatility3 |

## 2. Detailed Lesson Plan

### Key Concepts

- EDR (Endpoint Detection & Response) concepts: continuous telemetry, process-tree visualization, behavioral rules vs signatures
- Windows privilege/persistence Event IDs: 4672 (special privileges assigned), 4720 (user account created), 4732 (added to security-enabled group), 4698 (scheduled task created)
- Linux auditd: watch rules (auditctl -w), searching audit logs (ausearch -k <key>)
- UEBA (User and Entity Behavior Analytics): establishing behavioral baselines, deviation/anomaly scoring, common insider-threat indicators (odd-hour access, mass downloads, privilege abuse)
- Threat hunting fundamentals: hypothesis-driven hunting ('assume breach'), hunting mapped to MITRE ATT&CK techniques rather than waiting for alerts
- Basic digital forensics: order of volatility, memory acquisition/triage, process-list and network-connection artifacts in a memory image, high-level timeline analysis concept

### Industry Frameworks Referenced

- MITRE ATT&CK (technique-driven hunting: T1078 Valid Accounts, T1053 Scheduled Task, T1055 Process Injection)
- NIST SP 800-86 (Guide to Integrating Forensic Techniques into Incident Response) — conceptual reference

### Tools & Commands

- Wazuh (open-source EDR/HIDS agent + manager)
- auditd, ausearch, auditctl
- Sysinternals Suite (Process Explorer, Autoruns, TCPView)
- Velociraptor (VQL hunting queries) or PowerShell equivalents
- Volatility3 (memory forensics)

## 3. Practical Lab

See full lab blueprint: [`labs/lab-5.1-endpoint-detection-threat-hunt-and-memory-triage.md`](../labs/lab-5.1-endpoint-detection-threat-hunt-and-memory-triage.md)

## 4. Assessment & Checkpoints

### Review Questions

1. Which Windows Event ID indicates a user was added to a security-enabled group, and why does a SOC care about this?
2. What is the difference between a signature-based detection and a behavioral (EDR-style) detection?
3. Explain what 'hypothesis-driven threat hunting' means and give one example hypothesis mapped to a MITRE ATT&CK technique.
4. What auditd command would you use to watch for changes to /etc/shadow, and what command retrieves matching events later?
5. Name two artifacts you can recover from a memory image using Volatility3 and what each tells an analyst.

### Hands-on Lab Challenge

Given a second memory image, identify the malicious process, its parent process, and any associated network connection within 30 minutes, and state which MITRE ATT&CK technique the behavior most likely represents.



