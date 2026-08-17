# Lab 3.1 — Solution: SIEM Build-Out and Detection Engineering

**Module:** [Module 3 — SIEM and Log Analysis](../../docs/03-siem-and-log-analysis.md)

---

## Step 1 — Confirm Docker Stack is Running

```bash
docker compose ps
# NAME            STATUS          PORTS
# splunk          Up (healthy)    0.0.0.0:8000->8000/tcp
# elasticsearch   Up (healthy)    0.0.0.0:9200->9200/tcp
# kibana          Up (healthy)    0.0.0.0:5601->5601/tcp
```

---

## Step 2 — Onboard Data into Splunk

### Via Splunk UI (Add Data Wizard)

1. Splunk → **Settings → Add Data → Upload**
2. Upload `Security-brute-force.evtx`
3. Source Type: Select **WinEventLog:Security** (or create new)
4. Index: Select **main**
5. Repeat for Zeek `conn.log` (sourcetype: `zeek:conn`, index: `zeek`)
6. Repeat for Zeek `dns.log` (sourcetype: `zeek:dns`, index: `zeek`)

### Via CLI (faster)

```bash
# Verify data landed in Splunk
# Open Splunk Search & Reporting
# Run: index=main | head 5
# Run: index=zeek sourcetype=zeek:conn | head 5
```

**Expected Search Result (index=main sample):**
```
EventCode=4625  Account Name=Administrator  Source Network Address=10.10.5.22
EventCode=4625  Account Name=Administrator  Source Network Address=10.10.5.22
EventCode=4625  Account Name=Administrator  Source Network Address=10.10.5.22
...
```

---

## Step 3 — Ingest Zeek Logs into ELK

### Filebeat Config Snippet for Zeek (add to filebeat.yml)

```yaml
- type: filestream
  id: zeek-conn
  paths:
    - /opt/lab-evidence/zeek/conn.log
  fields:
    log_type: zeek_conn
  fields_under_root: true
  tags: ["zeek", "network"]

- type: filestream
  id: zeek-dns
  paths:
    - /opt/lab-evidence/zeek/dns.log
  fields:
    log_type: zeek_dns
  fields_under_root: true
  tags: ["zeek", "dns"]
```

---

## Step 4 — SPL Detection Queries

### SPL Query 1 — Brute Force Detection (T1110)

```splunk
index=main sourcetype="WinEventLog:Security" EventCode=4625
| stats count by src_ip, dest_user
| where count > 5
| sort -count
| rename count as "Failed Attempts", src_ip as "Source IP", dest_user as "Target Account"
```

**Expected Output:**
```
Source IP       Target Account   Failed Attempts
10.10.5.22      Administrator    47
10.10.5.22      admin            23
192.168.1.44    svc_backup        9
```

**MITRE ATT&CK Mapping:** T1110.001 — Brute Force: Password Guessing

---

### SPL Query 2 — Port Scan Detection (T1046) from Zeek

```splunk
index=zeek sourcetype="zeek:conn"
| stats dc(dest_port) as unique_ports by src_ip
| where unique_ports > 20
| sort -unique_ports
| rename unique_ports as "Unique Ports Scanned", src_ip as "Source IP"
```

**Expected Output:**
```
Source IP       Unique Ports Scanned
10.10.3.15      142
192.168.5.22     31
```

**MITRE ATT&CK Mapping:** T1046 — Network Service Discovery

---

### SPL Query 3 — C2 Beaconing Detection (T1071)

```splunk
index=zeek sourcetype="zeek:conn"
| stats count avg(duration) as avg_dur stdev(duration) as stdev_dur by src_ip, dest_ip
| where count > 20 AND avg_dur < 5 AND stdev_dur < 1
| sort -count
| eval beacon_score = round(1 - (stdev_dur / (avg_dur + 0.001)), 2)
| where beacon_score > 0.8
| table src_ip, dest_ip, count, avg_dur, stdev_dur, beacon_score
```

**Expected Output:**
```
src_ip         dest_ip          count  avg_dur  stdev_dur  beacon_score
10.10.1.45     185.220.101.55   187    2.13     0.08       0.96
```

**MITRE ATT&CK Mapping:** T1071.001 — Application Layer Protocol: Web Protocols (HTTP/S C2 beaconing)

---

## Step 5 — KQL Equivalent Queries (Kibana)

### KQL Query 1 — Failed Logins (equivalent of SPL Query 1)

**KQL Filter in Kibana Discover:**
```kql
event.code:4625 AND event.outcome:failure
```

**Aggregation (Data Table Visualization):**
- Metrics: Count
- Buckets: Terms → `source.ip` (top 10), then Terms → `user.name` (top 5)

---

### KQL Query 2 — Port Scan (from Zeek data)

```kql
log_type:zeek_conn
```

**Aggregation (Lens/TSVB):**
- Unique Count of `destination.port` grouped by `source.ip`
- Filter: Unique Count > 20

---

### KQL Query 3 — Beaconing Pattern

```kql
log_type:zeek_conn AND destination.ip:* AND NOT destination.ip:10.10.0.0/8
```

**Aggregation:**
- Date Histogram (5-minute buckets)
- Group by `source.ip` + `destination.ip`
- Look for high-count pairs with regular interval (no gaps)

---

## Step 6 — Build Kibana Dashboards

### Dashboard 1: "Failed Logins Overview"

| Panel | Type | KQL / Settings |
|-------|------|---------------|
| Total failed logins (count) | Metric | `event.code:4625` |
| Failed logins over time | Line chart | `event.code:4625`, Date histogram |
| Top source IPs | Data Table | Terms agg on `source.ip` |
| Top targeted accounts | Pie chart | Terms agg on `user.name` |

### Dashboard 2: "Top Talkers & Port Scans"

| Panel | Type | KQL / Settings |
|-------|------|---------------|
| Top source IPs by bytes | Bar chart | Terms on `source.ip`, sum of `network.bytes` |
| Unique destination ports per source | Table | Unique count on `destination.port`, grouped by `source.ip` |
| Connection timeline | Line chart | Count over time, group by `source.ip` |

### Dashboard 3: "Malware/C2 Alerts"

| Panel | Type | KQL / Settings |
|-------|------|---------------|
| Beaconing candidates | Table | `count > 20`, `avg_duration < 5s` per src/dst pair |
| External connections | World map | Destination IPs on geo map |
| DNS queries to suspicious domains | Table | Zeek dns.log, filter for known-bad TLDs |

---

## Step 7 — Create a Scheduled Alert in Kibana

**Navigate to:** Stack Management → Rules → Create Rule → Elasticsearch query

```
Rule Name:    Brute Force Alert — Failed Logins
Check every: 1 minute
Look-back:   5 minutes

Query:
{
  "query": {
    "bool": {
      "filter": [
        { "term": { "event.code": "4625" } },
        { "range": { "@timestamp": { "gte": "now-5m" } } }
      ]
    }
  },
  "aggs": {
    "by_source_ip": {
      "terms": { "field": "source.ip", "min_doc_count": 5 }
    }
  }
}

Alert Condition: Number of matches > 0

Action: Send email to soc-team@company.com
  Subject: [ALERT] Possible Brute Force — {{context.message}}
```

**Verify Alert Fires:**
```bash
# Replay the brute-force EVTX data to trigger the rule
# Check Kibana → Rules → Execution history — should show "Active" status
```

---

## Lab Challenge — Slow/Low Brute Force Detection Solution

> New dataset: brute force spread over 2 hours (below standard 5-min threshold)

### SPL Query (Splunk)

```splunk
index=main sourcetype="WinEventLog:Security" EventCode=4625
| bucket _time span=2h
| stats count by _time, src_ip, dest_user
| where count > 3
| eval detection_note="Low-and-slow brute force: " + count + " attempts over 2-hour window"
| sort -count
```

### KQL Query (Kibana — 2-hour rolling window)

**Create a Rule with a 2-hour look-back window:**
- Look-back period: `2 hours`
- Threshold: ≥ 4 failures from the same source IP
- Group by: `source.ip` + `user.name`

**MITRE ATT&CK Mapping:** T1110.001 — Brute Force: Password Guessing  
*(Same technique, different timing — defenders should tune time window, not just thresholds)*

---

[⬅ Setup](./setup.md) | [Grading Rubric ➡](./grading-rubric.md)
