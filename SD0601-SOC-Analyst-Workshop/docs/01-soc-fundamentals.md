# Module 1 — SOC Fundamentals

**Schedule:** Day 1, Morning (09:00–13:00)  
**Total:** 4h &nbsp;(Lecture: 2h · Hands-on Lab: 2h)

[⬅ Back to README](../README.md) | [Lab Guide ➡](../labs/lab-1.1-att-ck-mapping-ticket-triage.md)

## 1. Hourly Breakdown

| Time Block | Format | Topic |
| --- | --- | --- |
| 09:00–09:30 | Lecture | SOC mission, Tier 1/2/3 roles, shift structures |
| 09:30–10:00 | Lecture | Blue Team vs Red Team vs Purple Team; Cyber Kill Chain |
| 10:00–10:30 | Lecture | MITRE ATT&CK framework walkthrough; NIST CSF overview |
| 10:30–10:45 | Break | — |
| 10:45–11:15 | Lecture | Security policies & SOPs: AUP, IR Policy, Escalation Matrix |
| 11:15–13:00 | Hands-on Lab | ATT&CK Navigator mapping + mock ticket triage exercise |

## 2. Detailed Lesson Plan

### Key Concepts

- SOC organizational model: Tier 1 (Triage/Monitoring), Tier 2 (Investigation), Tier 3 (Threat Hunting/Forensics), SOC Manager
- Blue Team defensive mindset vs Red Team offensive mindset vs Purple Team collaboration
- Cyber Threat Landscape: APT groups, ransomware-as-a-service, insider threats, supply-chain attacks
- Security Monitoring basics: what to monitor (assets, identities, network, cloud), monitoring maturity
- Security Policies & Procedures: Acceptable Use Policy, Incident Response Policy, Escalation Matrix, Chain of Custody basics
- Standard SOC workflow: Alert generation → Triage → Investigation → Escalation → Closure → Shift handover

### Industry Frameworks Referenced

- MITRE ATT&CK Enterprise Matrix (Tactics & Techniques, e.g., TA0001 Initial Access → T1566 Phishing)
- Lockheed Martin Cyber Kill Chain (7 stages: Recon → Actions on Objectives)
- NIST Cybersecurity Framework (Identify, Protect, Detect, Respond, Recover)

### Tools & Commands

- MITRE ATT&CK Navigator (web)
- TheHive / osTicket (mock ticketing queue)
- Google Sheets/Excel (SOC shift log template)

## 3. Practical Lab

See full lab blueprint: [`labs/lab-1.1-att-ck-mapping-ticket-triage.md`](../labs/lab-1.1-att-ck-mapping-ticket-triage.md)

## 4. Assessment & Checkpoints

### Review Questions

1. What differentiates the responsibilities of an L1 SOC Analyst from an L2 SOC Analyst?
2. Map 'attacker sends a spear-phishing email with a malicious macro' to the correct MITRE ATT&CK Tactic and Technique ID.
3. Explain the difference between a False Positive and a Benign-Positive alert, with one example each.
4. List the 7 stages of the Lockheed Martin Cyber Kill Chain in order.
5. Why does a SOC need a documented Escalation Matrix? What happens without one?

### Hands-on Lab Challenge

Given a new 4-stage attack narrative, produce a complete ATT&CK Navigator layer and correctly triage 5 additional mock tickets within 30 minutes.


