# Solutions — SD0601 SOC Analyst Workshop

> **Instructor Reference Only.** These solution modules are for instructor use during delivery. Each module is self-contained and mirrors the corresponding lab in `labs/`.

---

## ⚡ Automated Lab Automation Platform vs. Manual Setup

The workshop supports **two operational deployment modes**:

1. **Automated Orchestration Platform (Recommended)**: Use the automated `sd0601-lab-automation` platform controller to provision, configure, verify, and reset any lab in seconds.
   ```bash
   # On Docker Host:
   ./sd0601.sh install           # Preflight + Docker stack setup
   ./sd0601.sh lab setup 2.1     # Prepare Lab 2.1
   ./sd0601.sh lab verify 2.1    # Automated verification check

   # On Windows VM:
   setup.bat lab 2.1             # Automated Windows setup & telemetry

   # On Ubuntu VM:
   ./setup.sh lab 2.1            # Automated Linux setup & telemetry
   ```

2. **Manual Step-by-Step Setup**: Follow the manual commands documented in each lab's `setup.md` and `solution.md`.

---

## Module Index

| Lab | Title | Solution Folder | Automated Setup |
|-----|-------|----------------|-----------------|
| Lab 1.1 | ATT&CK Mapping & Ticket Triage | [`lab-1.1-att-ck-mapping-ticket-triage/`](./lab-1.1-att-ck-mapping-ticket-triage/) | `./sd0601.sh lab setup 1.1` |
| Lab 2.1 | Log Pipeline: Endpoint to SIEM | [`lab-2.1-log-pipeline-endpoint-to-siem/`](./lab-2.1-log-pipeline-endpoint-to-siem/) | `./sd0601.sh lab setup 2.1` |
| Lab 3.1 | SIEM Build-Out and Detection Engineering | [`lab-3.1-siem-build-out-and-detection-engineering/`](./lab-3.1-siem-build-out-and-detection-engineering/) | `./sd0601.sh lab setup 3.1` |
| Lab 4.1 | IOC Enrichment, YARA, and Full Case Lifecycle | [`lab-4.1-ioc-enrichment-yara-and-full-case-lifecycle/`](./lab-4.1-ioc-enrichment-yara-and-full-case-lifecycle/) | `./sd0601.sh lab setup 4.1` |
| Lab 5.1 | Endpoint Detection, Threat Hunt, and Memory Triage | [`lab-5.1-endpoint-detection-threat-hunt-and-memory-triage/`](./lab-5.1-endpoint-detection-threat-hunt-and-memory-triage/) | `./sd0601.sh lab setup 5.1` |
| Lab 6.1 | Atomic Red Team Live-Fire Detection Drill | [`lab-6.1-atomic-red-team-live-fire-detection-drill/`](./lab-6.1-atomic-red-team-live-fire-detection-drill/) | `./sd0601.sh lab setup 6.1` |

---

## Each Module Contains

| File | Purpose |
|------|---------|
| `setup.md` | Environment prerequisites, automated CLI commands, manual tool installation & stack startup |
| `solution.md` | Full step-by-step solution with commands, automated verification checks, expected outputs, and MITRE ATT&CK mappings |
| `grading-rubric.md` | Scoring criteria aligned to lab expected outcomes |
| `assets/` | Supporting files: docker-compose, configs, queries, rules, templates |

---

## Environment Architecture & RAM Profiles

```
┌─────────────────────────────────────────────┐
│  Docker Host (8GB / 16GB / 32GB+ RAM)       │
│  ├── ELK Stack (Elasticsearch + Kibana)     │
│  ├── Splunk Free                            │
│  ├── Wazuh Manager                         │
│  ├── TheHive + Cortex                      │
│  └── MISP                                  │
│                                             │
│  Windows 10/11 VM (4GB+ RAM)               │
│  ├── Sysmon (SwiftOnSecurity config)        │
│  ├── Winlogbeat                             │
│  └── Wazuh Agent                           │
│                                             │
│  Ubuntu 22.04 VM (2GB+ RAM)                │
│  ├── Filebeat                              │
│  ├── auditd                                │
│  └── Wazuh Agent                           │
└─────────────────────────────────────────────┘
```

---

[⬅ Back to Workshop README](../README.md)
