# Lab 3.1 — SIEM Build-Out and Detection Engineering

**Module:** [Module 3 — SIEM and Log Analysis](../docs/03-siem-and-log-analysis.md)

## Scenario

Instructor provides: (a) a sample EVTX export containing brute-force and privilege-escalation activity, and (b) Zeek network logs containing a port scan and a beaconing C2 pattern. Students ingest both into Splunk AND ELK and build detections.

## Step-by-Step

1. Bring up the provided docker-compose stack (Splunk + ELK) and confirm both UIs are reachable.
2. In Splunk, onboard the EVTX file via the Add Data wizard (sourcetype=WinEventLog:Security); in Kibana, ingest the same file via a Filebeat/Logstash pipeline with a grok/XML filter.
3. Ingest Zeek conn.log and dns.log into both platforms.
4. SPL Query 1 (Brute Force): index=main sourcetype=WinEventLog:Security EventCode=4625 | stats count by src_ip, dest_user | where count > 5
5. SPL Query 2 (Port Scan, from Zeek conn.log): index=zeek sourcetype=zeek:conn | stats dc(dest_port) as ports by src_ip | where ports > 20
6. SPL Query 3 (Beaconing): index=zeek sourcetype=zeek:conn | stats count avg(duration) by src_ip, dest_ip | sort - count (look for highly regular, repeated short connections to one destination)
7. Kibana KQL equivalents: event.code:4625 and event.outcome:failure (aggregate by source.ip and user.name using a Data Table visualization); destination.port cardinality aggregation for port-scan; connection-count aggregation per source/destination pair for beaconing.
8. Build 3 Kibana/Splunk dashboards: 'Failed Logins Overview', 'Top Talkers & Port Scans', 'Malware/C2 Alerts'.
9. Save one query as a scheduled alert (Splunk: Save As Alert, trigger = per-result, action = send email/webhook; Kibana: Stack Management → Rules → threshold rule) and demonstrate it firing.

## Expected Outcomes

- Functional Splunk + ELK stacks with ingested EVTX and Zeek data
- 3 working detection queries mapped to MITRE ATT&CK Technique IDs
- 3 dashboards and one demonstrably firing alert

## Hands-on Lab Challenge

Given a new, unseen Zeek dataset containing a slow/low-and-slow brute-force pattern (spread over 2 hours), write a working SPL or KQL query that still detects it within a 60-minute lab window, and map the detection to its MITRE ATT&CK Technique ID.



