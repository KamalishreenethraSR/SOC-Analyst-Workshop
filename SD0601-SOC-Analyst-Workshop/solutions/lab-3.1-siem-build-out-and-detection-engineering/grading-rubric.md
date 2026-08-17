# Lab 3.1 — Grading Rubric: SIEM Build-Out and Detection Engineering

**Total Points: 100**

---

## Part 1 — Stack Setup & Data Ingestion (20 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| Splunk + ELK both reachable and healthy | 5 | Show both UIs loading; Elasticsearch `_cluster/health` not red |
| EVTX data onboarded into Splunk (correct sourcetype + index) | 5 | `index=main EventCode=4625 | head 1` returns results |
| Zeek logs onboarded into both Splunk and ELK | 5 | `index=zeek sourcetype=zeek:conn | head 1` and Kibana Discover filter |
| Kibana index pattern created and events visible | 5 | Student demonstrates events in Kibana Discover with correct timestamps |

---

## Part 2 — SPL Queries (30 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| SPL Query 1 (Brute Force): syntactically correct and returns results | 8 | Run in Splunk; at least one IP with > 5 failures shown |
| SPL Query 2 (Port Scan): correct use of `dc()` and threshold | 8 | Shows source IPs with > 20 unique destination ports |
| SPL Query 3 (Beaconing): uses `avg()` and `stdev()` with filter | 8 | Identifies at least one src/dst pair as beaconing candidate |
| MITRE ATT&CK technique IDs cited for all 3 queries | 6 | Correct IDs in comments, notes, or documentation: T1110, T1046, T1071 |

---

## Part 3 — KQL Equivalents (15 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| KQL Query 1 equivalent (failed logins, `event.code:4625`) | 5 | Kibana Discover filter shown; aggregation on source.ip |
| KQL Query 2 equivalent (port scan aggregation) | 5 | Unique count of destination.port per source.ip visualized |
| KQL Query 3 equivalent (beaconing — date histogram with grouping) | 5 | Time-series chart showing connection regularity to external IP |

---

## Part 4 — Dashboards (20 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| Dashboard 1: "Failed Logins Overview" — at least 3 panels | 7 | Count metric + time chart + source IP table all visible |
| Dashboard 2: "Top Talkers & Port Scans" — at least 2 panels | 6 | Top IPs by connection count + unique port count table |
| Dashboard 3: "Malware/C2 Alerts" — at least 2 panels | 7 | Beaconing table + external connection visualization |

---

## Part 5 — Scheduled Alert (15 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| Alert created in either Splunk or Kibana | 5 | Alert configuration visible in UI |
| Alert fires and is demonstrably triggered | 7 | Alert shows "Active" or "Fired" state after data ingestion |
| Alert action configured (email, webhook, or similar) | 3 | Action shown in alert configuration |

---

## Lab Challenge Bonus (10 bonus points)

| Criterion | Points |
|-----------|--------|
| Slow brute force SPL/KQL query written with 2-hour window | 4 |
| Query correctly detects low-rate activity that 5-min query misses | 4 |
| MITRE ATT&CK technique correctly identified (T1110.001) | 2 |

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
