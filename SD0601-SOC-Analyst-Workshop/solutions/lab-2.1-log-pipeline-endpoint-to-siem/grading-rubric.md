# Lab 2.1 — Grading Rubric: Log Pipeline: Endpoint to SIEM

**Total Points: 100**

---

## Part 1 — Pipeline Setup (40 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| Sysmon installed and running on Windows VM | 5 | `Get-Service Sysmon64` shows Running |
| Sysmon config correctly loaded (SwiftOnSecurity or equivalent) | 5 | `Sysmon64.exe -c` shows config path; verify at least 10 event filter rules |
| Winlogbeat installed and shipping Security + Sysmon/Operational channels | 10 | Index `winlogbeat-*` exists in Elasticsearch with events from both channels |
| Filebeat installed and shipping auth.log + syslog | 10 | Index `filebeat-*` exists with events from `/var/log/auth.log` |
| Kibana index patterns created for both indices | 5 | Both `winlogbeat-*` and `filebeat-*` visible in Kibana Discover |
| Events visible in Kibana Discover for both Windows and Linux | 5 | Student can demonstrate events in Kibana; timestamp filters working |

---

## Part 2 — Telemetry Generation & Verification (25 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| Windows: process creation events visible for notepad.exe and powershell.exe | 8 | Filter Kibana for `event.code:1` AND `process.name:notepad.exe` |
| Windows: network connection event visible for Invoke-WebRequest | 7 | Filter Kibana for `event.code:3` AND `destination.domain:example.com` |
| Linux: 5+ failed SSH login events visible in Kibana | 10 | Filter `filebeat-*` for `message:"Failed password"` — at least 5 results |

---

## Part 3 — Manual Correlation Rule (35 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| grep/awk command is syntactically correct | 5 | Command runs without error and produces output |
| Command correctly extracts source IPs from auth.log | 10 | Correct field number used (`$11`) and output shows IP:count pairs |
| Correlation rule includes: event source, threshold, time window | 10 | Written rule has all three components |
| Correlation rule references the correct MITRE ATT&CK technique | 5 | Must mention T1110 or T1110.001 (Brute Force) |
| Kibana/ES aggregation query provided or described | 5 | Student shows JSON query or describes agg type used |

---

## Lab Challenge Bonus (10 bonus points)

| Criterion | Points |
|-----------|--------|
| Filebeat configured with a second log source (apache2 or sudo log) | 4 |
| Events from the new source visible in Kibana Discover | 4 |
| Completed within 40-minute timer | 2 |

---

## Grading Notes

- **Pipeline not working:** If Winlogbeat or Filebeat is not shipping, partial credit for configuration files (correctly configured YAML = 5 pts each even with no data)
- **grep/awk:** Accept any command that correctly extracts and counts source IPs; the exact field number may vary if auth.log format differs
- **Correlation rule:** Must be written in plain language or pseudo-code — does not need to be a working Kibana/ES rule for full marks

---

## Scoring Bands

| Score | Band |
|-------|------|
| 90–100 | Distinction |
| 75–89 | Merit |
| 60–74 | Pass |
| < 60 | Requires Re-sit |

---

[⬅ Solution](./solution.md) | [⬅ Back to Solutions Index](../README.md)
