# Module 4 — Threat Detection and Incident Response

**Schedule:** Day 3, Full Day (09:00–21:00)  
**Total:** 12h &nbsp;(Lecture: 4h · Hands-on Lab: 8h)

[⬅ Back to README](../README.md) | [Lab Guide ➡](../labs/lab-4.1-ioc-enrichment-yara-and-full-case-lifecycle.md)

## 1. Hourly Breakdown

| Time Block  | Format       | Topic                                                                         |
| ----------- | ------------ | ----------------------------------------------------------------------------- |
| 09:00–09:45 | Lecture      | IOCs vs IOAs; malware detection fundamentals (static vs dynamic analysis)     |
| 09:45–10:30 | Lecture      | Incident Response Lifecycle — NIST SP 800-61 & SANS PICERL                    |
| 10:30–10:45 | Break        | —                                                                             |
| 10:45–11:30 | Lecture      | Threat Intelligence Platforms: MISP, OpenCTI, VirusTotal, AbuseIPDB           |
| 11:30–13:00 | Hands-on Lab | IOC enrichment: hash/domain/IP lookups + MISP event creation                  |
| 14:00–14:45 | Lecture      | Case management workflow with TheHive + Cortex analyzers                      |
| 14:45–18:00 | Hands-on Lab | YARA rule authoring + malware triage on a sample binary                       |
| 19:00–21:00 | Hands-on Lab | Full case walk-through: alert → TheHive case → IR lifecycle stages documented |

## 2. Detailed Lesson Plan

### Key Concepts

- IOC (Indicator of Compromise: hash, IP, domain, registry key, filename) vs IOA (Indicator of Attack: behavior pattern)
- Malware detection fundamentals: signature-based vs heuristic vs behavioral detection; static analysis (strings, PE headers) vs dynamic analysis (sandboxing)
- NIST SP 800-61 IR Lifecycle: Preparation → Detection & Analysis → Containment, Eradication & Recovery → Post-Incident Activity
- SANS PICERL model: Preparation, Identification, Containment, Eradication, Recovery, Lessons Learned
- Alert investigation workflow: initial triage → enrichment → scoping → verdict → escalation/closure
- Threat Intelligence Platform concepts: IOC sharing (STIX/TAXII), threat feeds, pivoting on indicators
- Case management: evidence attachment, task assignment, SLA tracking, case closure with verdict

### Industry Frameworks Referenced

- NIST SP 800-61 Rev. 2 (Computer Security Incident Handling Guide)
- SANS PICERL Incident Response Model
- MITRE ATT&CK (technique-level classification of observed behavior)
- STIX/TAXII (threat intelligence sharing standards — conceptual overview)

### Tools & Commands

- VirusTotal (UI + API)
- AbuseIPDB
- MISP (Malware Information Sharing Platform)
- TheHive + Cortex analyzers
- YARA
- sha256sum / Get-FileHash

## 3. Practical Lab

See full lab blueprint: [`labs/lab-4.1-ioc-enrichment-yara-and-full-case-lifecycle.md`](../labs/lab-4.1-ioc-enrichment-yara-and-full-case-lifecycle.md)

## 4. Assessment & Checkpoints

### Review Questions

1. Differentiate an IOC from an IOA with one real-world example of each.
2. List the four phases of the NIST SP 800-61 Incident Response Lifecycle.
3. What is the purpose of a YARA rule, and what are its three main sections?
4. Why is TLP (Traffic Light Protocol) marking important when sharing threat intelligence?
5. Describe the difference between containment, eradication, and recovery with one action each.

### Hands-on Lab Challenge

Given a second, unseen malware sample and phishing artifact, complete the full enrichment-to-case-closure workflow (hash lookup → MISP event → YARA rule → TheHive case through all 4 IR phases) within 45 minutes.
