# Module 2 — Security Monitoring and Log Management

**Schedule:** Day 1, Afternoon & Evening (14:00–21:00)  
**Total:** 8h &nbsp;(Lecture: 3h · Hands-on Lab: 5h)

[⬅ Back to README](../README.md) | [Lab Guide ➡](../labs/lab-2.1-log-pipeline-endpoint-to-siem.md)

## 1. Hourly Breakdown

| Time Block  | Format       | Topic                                                                                         |
| ----------- | ------------ | --------------------------------------------------------------------------------------------- |
| 14:00–14:45 | Lecture      | Log sources & collection pipelines: firewall, AD, DNS, proxy, endpoint                        |
| 14:45–15:30 | Lecture      | Windows Event Log architecture + Sysmon; Linux syslog/journald architecture                   |
| 15:30–16:15 | Lecture      | Event correlation concepts & alert prioritization (severity x confidence x asset criticality) |
| 16:15–16:30 | Break        | —                                                                                             |
| 16:30–18:00 | Hands-on Lab | Sysmon deployment + Winlogbeat/Filebeat shipping to Elasticsearch                             |
| 19:00–21:00 | Hands-on Lab | Log parsing with grep/awk/PowerShell + build a manual correlation rule                        |

## 2. Detailed Lesson Plan

### Key Concepts

- Log source taxonomy: network (firewall, IDS/IPS, proxy, DNS), host (Windows/Linux event logs), application, cloud (CloudTrail/Azure Activity Log — conceptual)
- Windows Event Log channels: Security, System, Application, and Sysmon operational log; key Event IDs (4624 logon, 4625 failed logon, 4688 process creation, 4720 user created)
- Linux logging: /var/log/auth.log, /var/log/syslog, journald, auditd basics
- Log collection pipeline: Agent (Winlogbeat/Filebeat/Sysmon) → Shipper (Logstash) → Storage & Search (Elasticsearch) → Visualization (Kibana)
- Event correlation fundamentals: time-window correlation, same-source correlation, sequence-based correlation
- Alert prioritization formula: Severity x Confidence x Asset Criticality = Priority Score

### Industry Frameworks Referenced

- NIST SP 800-92 (Guide to Computer Security Log Management)
- MITRE ATT&CK Data Sources mapping (e.g., DS0009 Process, DS0022 File)

### Tools & Commands

- Sysmon (SwiftOnSecurity config)
- Winlogbeat / Filebeat
- Elasticsearch + Kibana (Docker)
- journalctl, auditd, ausearch
- grep, awk, sed, PowerShell Get-WinEvent

## 3. Practical Lab

See full lab blueprint: [`labs/lab-2.1-log-pipeline-endpoint-to-siem.md`](../labs/lab-2.1-log-pipeline-endpoint-to-siem.md)

## 4. Assessment & Checkpoints

### Review Questions

1. Name three Windows Event IDs relevant to SOC monitoring and what each indicates.
2. What is the role of Sysmon, and how does it differ from native Windows Security auditing?
3. Describe the log pipeline flow from endpoint agent to Kibana dashboard.
4. Write the Linux command to extract failed SSH login attempts from auth.log and count occurrences per source IP.
5. Why is alert prioritization necessary — what happens in a SOC that treats every alert as equal priority?

### Hands-on Lab Challenge

Within 40 minutes, stand up Filebeat shipping a second Linux log source (e.g., /var/log/apache2/access.log or a sample sudo log) into the same Elasticsearch cluster and confirm field extraction in Kibana Discover.
