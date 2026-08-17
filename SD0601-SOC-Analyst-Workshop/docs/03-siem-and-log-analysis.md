# Module 3 — SIEM and Log Analysis

**Schedule:** Day 2, Full Day (09:00–21:00)  
**Total:** 12h &nbsp;(Lecture: 4h · Hands-on Lab: 8h)

[⬅ Back to README](../README.md) | [Lab Guide ➡](../labs/lab-3.1-siem-build-out-and-detection-engineering.md)

## 1. Hourly Breakdown

| Time Block  | Format       | Topic                                                                     |
| ----------- | ------------ | ------------------------------------------------------------------------- |
| 09:00–09:45 | Lecture      | SIEM architecture: forwarders/collectors, indexers, search heads          |
| 09:45–10:30 | Lecture      | Splunk fundamentals: SPL syntax, indexes, sourcetypes                     |
| 10:30–10:45 | Break        | —                                                                         |
| 10:45–11:30 | Lecture      | ELK Stack fundamentals: Logstash grok filters, Elasticsearch indices, KQL |
| 11:30–13:00 | Hands-on Lab | Deploy Splunk Free + ELK via docker-compose; ingest sample EVTX/Zeek data |
| 14:00–14:45 | Lecture      | Dashboard design principles + saved searches & alert actions              |
| 14:45–18:00 | Hands-on Lab | Build SPL/KQL detection queries for brute force, port scan, beaconing     |
| 19:00–21:00 | Hands-on Lab | Build 3 dashboards + configure one live alert with webhook/email action   |

## 2. Detailed Lesson Plan

### Key Concepts

- SIEM core architecture: Data Collection → Normalization/Parsing → Indexing → Correlation → Alerting → Reporting
- Splunk components: Universal/Heavy Forwarder, Indexer, Search Head; index vs sourcetype vs source
- Splunk SPL: search, stats, eval, timechart, transaction, where, rex
- ELK Stack components: Beats/Logstash (ingest), Elasticsearch (index/search), Kibana (visualize)
- Logstash grok patterns for unstructured log parsing; field mapping in Elasticsearch
- KQL (Kibana Query Language) vs Lucene syntax vs SPL — practical comparison
- Dashboard design: single-pane-of-glass principle, drill-downs, panel refresh intervals
- Detection engineering basics: threshold-based rules vs statistical/behavioral rules

### Industry Frameworks Referenced

- NIST SP 800-92
- MITRE ATT&CK (mapping detections to Technique IDs, e.g., T1110 Brute Force, T1046 Network Service Discovery)

### Tools & Commands

- Splunk Enterprise Free trial (or Splunk Docker image)
- ELK Stack via docker-compose (Elasticsearch, Logstash, Kibana)
- Sample datasets: Windows Security EVTX, Zeek conn.log/dns.log, Suricata eve.json

## 3. Practical Lab

See full lab blueprint: [`labs/lab-3.1-siem-build-out-and-detection-engineering.md`](../labs/lab-3.1-siem-build-out-and-detection-engineering.md)

## 4. Assessment & Checkpoints

### Review Questions

1. Explain the difference between an index, a sourcetype, and a source in Splunk.
2. Write an SPL query to count failed logon attempts (EventCode 4625) grouped by source IP where the count exceeds 5.
3. What is a grok filter used for in Logstash, and why is it needed for unstructured logs?
4. Describe how you would detect a port-scan using Zeek conn.log data and what field(s) you'd aggregate on.
5. What factors should guide whether a detection is threshold-based or behavioral/statistical?

### Hands-on Lab Challenge

Given a new, unseen Zeek dataset containing a slow/low-and-slow brute-force pattern (spread over 2 hours), write a working SPL or KQL query that still detects it within a 60-minute lab window, and map the detection to its MITRE ATT&CK Technique ID.
