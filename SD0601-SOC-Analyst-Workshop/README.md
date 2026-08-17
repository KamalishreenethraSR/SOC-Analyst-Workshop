# SD0601 — SOC Analyst: Security Monitoring and Incident Response

![Duration](https://img.shields.io/badge/Duration-60%20Hours-1F3864) ![Format](https://img.shields.io/badge/Format-5--Day%20Bootcamp-2E5395) ![Level](https://img.shields.io/badge/Level-L1%2FL2%20SOC%20Analyst-B8860B)

A complete, hands-on **60-hour, 5-day workshop curriculum** for training aspiring L1/L2 SOC Analysts and Cybersecurity Engineers — covering SOC fundamentals, log management, SIEM engineering (Splunk & ELK), threat detection & incident response, endpoint/network monitoring, and a full live-fire capstone breach simulation.

## Core Learning Objectives

- Understand SOC operations, tiers, and standard operating workflows.
- Ingest, parse, and analyze system and network logs using SIEM platforms.
- Detect, triage, and respond to live security incidents across endpoints and networks.
- Conduct threat hunting methodologies and preliminary digital forensic investigations.
- Author incident response documentation, escalation tickets, and executive reports.

## 5-Day Master Schedule

| Day   | Theme                                    | Modules             | Hours |
| ----- | ---------------------------------------- | ------------------- | ----- |
| Day 1 | SOC Foundations & Log Management         | Module 1 + Module 2 | 12    |
| Day 2 | SIEM Engineering (Splunk & ELK)          | Module 3            | 12    |
| Day 3 | Threat Detection & Incident Response     | Module 4            | 12    |
| Day 4 | Endpoint, Network Monitoring & Forensics | Module 5            | 12    |
| Day 5 | Live SOC Simulation & Capstone Breach    | Module 6            | 12    |

**Daily timing:** 09:00–13:00 (Block A, 4h) | 14:00–18:00 (Block B, 4h) | 19:00–21:00 (Block C, 2h, labs/debrief) — two short breaks per block

## Curriculum (Modules)

| #   | Module                                             | Docs                                                                                                                       |
| --- | -------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| 1   | SOC Fundamentals                                   | [`docs/01-soc-fundamentals.md`](docs/01-soc-fundamentals.md)                                                               |
| 2   | Security Monitoring and Log Management             | [`docs/02-security-monitoring-and-log-management.md`](docs/02-security-monitoring-and-log-management.md)                   |
| 3   | SIEM and Log Analysis                              | [`docs/03-siem-and-log-analysis.md`](docs/03-siem-and-log-analysis.md)                                                     |
| 4   | Threat Detection and Incident Response             | [`docs/04-threat-detection-and-incident-response.md`](docs/04-threat-detection-and-incident-response.md)                   |
| 5   | Endpoint and Network Monitoring                    | [`docs/05-endpoint-and-network-monitoring.md`](docs/05-endpoint-and-network-monitoring.md)                                 |
| 6   | SOC Operations and Practical Labs (incl. Capstone) | [`docs/06-soc-operations-and-practical-labs-incl-capstone.md`](docs/06-soc-operations-and-practical-labs-incl-capstone.md) |

## Labs

| Lab                                                          | File                                                                                                                                   |
| ------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| Lab 1.1 — ATT&CK Mapping & Ticket Triage                     | [`labs/lab-1.1-att-ck-mapping-ticket-triage.md`](labs/lab-1.1-att-ck-mapping-ticket-triage.md)                                         |
| Lab 2.1 — Log Pipeline: Endpoint to SIEM                     | [`labs/lab-2.1-log-pipeline-endpoint-to-siem.md`](labs/lab-2.1-log-pipeline-endpoint-to-siem.md)                                       |
| Lab 3.1 — SIEM Build-Out and Detection Engineering           | [`labs/lab-3.1-siem-build-out-and-detection-engineering.md`](labs/lab-3.1-siem-build-out-and-detection-engineering.md)                 |
| Lab 4.1 — IOC Enrichment, YARA, and Full Case Lifecycle      | [`labs/lab-4.1-ioc-enrichment-yara-and-full-case-lifecycle.md`](labs/lab-4.1-ioc-enrichment-yara-and-full-case-lifecycle.md)           |
| Lab 5.1 — Endpoint Detection, Threat Hunt, and Memory Triage | [`labs/lab-5.1-endpoint-detection-threat-hunt-and-memory-triage.md`](labs/lab-5.1-endpoint-detection-threat-hunt-and-memory-triage.md) |
| Lab 6.1 — Atomic Red Team Live-Fire Detection Drill          | [`labs/lab-6.1-atomic-red-team-live-fire-detection-drill.md`](labs/lab-6.1-atomic-red-team-live-fire-detection-drill.md)               |

## Capstone

**Operation SilentLedger** — a 5-stage, multi-day fintech breach simulation (phishing → persistence → credential theft → lateral movement → exfiltration) reconstructed entirely from provided forensic evidence (EVTX, Zeek logs, memory image, phishing artifact).

See [`capstone/operation-silentledger.md`](capstone/operation-silentledger.md).

## Repository Structure

```
SD0601-SOC-Analyst-Workshop/
├── README.md
├── LICENSE
├── docs/          # One lesson-plan file per module (hourly breakdown, concepts, frameworks, assessment)
│   ├── 01-soc-fundamentals.md
│   ├── 02-security-monitoring-and-log-management.md
│   ├── 03-siem-and-log-analysis.md
│   ├── 04-threat-detection-and-incident-response.md
│   ├── 05-endpoint-and-network-monitoring.md
│   ├── 06-soc-operations-and-practical-labs-incl-capstone.md
├── labs/          # Step-by-step practical lab blueprints, one per module
│   ├── lab-1.1-att-ck-mapping-ticket-triage.md
│   ├── lab-2.1-log-pipeline-endpoint-to-siem.md
│   ├── lab-3.1-siem-build-out-and-detection-engineering.md
│   ├── lab-4.1-ioc-enrichment-yara-and-full-case-lifecycle.md
│   ├── lab-5.1-endpoint-detection-threat-hunt-and-memory-triage.md
│   ├── lab-6.1-atomic-red-team-live-fire-detection-drill.md
└── capstone/
    └── operation-silentledger.md   # Final multi-stage breach simulation
```

## Lab Environment Prerequisites

- 1x Windows 10/11 VM (4GB+ RAM) — Sysmon, Winlogbeat, Wazuh agent
- 1x Ubuntu 22.04 VM (4GB+ RAM) — Filebeat, auditd, Wazuh agent
- 1x Docker host (8GB+ RAM) — Splunk Free, ELK stack, TheHive+Cortex, MISP, Wazuh manager (docker-compose)
- Instructor-provided evidence packages: sample EVTX exports, Zeek/Suricata logs, phishing `.eml` samples, safe/benign test binaries, one memory image (`.mem`) for the capstone
- Atomic Red Team PowerShell module pre-installed on the Windows victim VM (Day 5)

## Safety & Ethics Note

All malware samples, phishing artifacts, and attack simulations used in this course are de-fanged, synthetic, or industry-standard safe test files (e.g., EICAR). Atomic Red Team tests run only inside the isolated lab environment, never against production systems. All techniques are taught strictly for defensive detection-engineering purposes.

## License

This curriculum is released for educational and training use. See [LICENSE](LICENSE).

<!-- CHECKPOINT id="ckpt_mst0jnw3_b0aawn" time="2026-08-14T13:59:12.051Z" note="auto" fixes=0 questions=0 highlights=0 sections="" -->
