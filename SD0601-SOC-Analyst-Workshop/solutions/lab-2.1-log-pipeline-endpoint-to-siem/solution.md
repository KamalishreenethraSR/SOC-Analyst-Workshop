# Lab 2.1 — Solution: Log Pipeline: Endpoint to SIEM

**Module:** [Module 2 — Security Monitoring and Log Management](../../docs/02-security-monitoring-and-log-management.md)

---

## Step 1 — Install Sysmon on Windows VM

**Command (Administrator PowerShell):**
```powershell
C:\Tools\Sysmon\Sysmon64.exe -accepteula -i C:\Tools\Sysmon\sysmonconfig.xml
```

**Expected Output:**
```
System Monitor v15.0 - System activity monitor
Copyright (C) 2014-2023 Mark Russinovich and Thomas Garnier
Sysinternals - www.sysinternals.com

Loading configuration file with schema version 4.50
Sysmon schema version: 4.90
Configuration file validated.
Sysmon64 installed.
SysmonDrv installed.
Starting SysmonDrv.
SysmonDrv started.
Starting Sysmon64..
Sysmon64 started.
```

**Verify:**
```powershell
Get-Service Sysmon64 | Select-Object Status, Name
# Status  Name
# ------  ----
# Running Sysmon64

# Verify events are appearing in Event Viewer
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 5 |
  Select-Object TimeCreated, Id, Message | Format-List
```

---

## Step 2 — Generate Test Telemetry on Windows

```powershell
# Generate process creation event (Sysmon Event ID 1)
notepad.exe

# Generate network connection event (Sysmon Event ID 3)
powershell.exe -Command "Invoke-WebRequest http://example.com"
```

**Expected Sysmon Events Generated:**
| Event ID | Event Name | Trigger |
|----------|-----------|---------|
| 1 | Process Create | notepad.exe spawned |
| 1 | Process Create | powershell.exe spawned |
| 3 | Network Connection | powershell.exe → 93.184.216.34:80 (example.com) |
| 22 | DNS Query | DNS lookup for example.com |

---

## Step 3 — Install and Configure Winlogbeat

**Config verification:**
```powershell
cd "C:\Program Files\Winlogbeat\winlogbeat"
.\winlogbeat.exe test config -c winlogbeat.yml -e
# Expected: Config OK
```

**Check logs for successful shipping:**
```powershell
# View Winlogbeat logs
Get-Content "C:\ProgramData\winlogbeat\Logs\winlogbeat" -Tail 20
# Look for: "Connection to backoff(elasticsearch(...)) established"
# Look for: "events published" lines
```

**Expected Kibana Index:**
```bash
# On Docker host, verify index was created
curl -u elastic:changeme -s http://localhost:9200/_cat/indices/winlogbeat-* | column -t
# Expected output (example):
# green open winlogbeat-8.13.0-2024.08.14 ... 1 0 4523 0 3.8mb 3.8mb
```

---

## Step 4 — Ubuntu VM: Configure Filebeat and Generate Events

**Generate failed SSH events:**
```bash
# Attempt 5 failed logins (will fail — that's the point)
for i in {1..5}; do ssh baduser@localhost; done
# Enter random passwords when prompted; all will fail
```

**Verify events in auth.log:**
```bash
sudo grep 'Failed password' /var/log/auth.log | tail -5
# Expected:
# Aug 14 14:22:01 ubuntu sshd[12345]: Failed password for invalid user baduser from 127.0.0.1 port 54321 ssh2
# Aug 14 14:22:03 ubuntu sshd[12347]: Failed password for invalid user baduser from 127.0.0.1 port 54323 ssh2
# ... (5 lines total)
```

**Start Filebeat and verify:**
```bash
sudo systemctl start filebeat
sudo systemctl status filebeat
# Active: active (running)

# Check Filebeat logs
sudo journalctl -u filebeat -n 30
# Look for: "Connection to backoff(elasticsearch(...)) established"
# Look for: "events published"
```

---

## Step 5 — Kibana Index Pattern Creation

Navigate to Kibana → `Stack Management → Index Patterns → Create index pattern`

| Index Pattern | Timestamp Field |
|---|---|
| `winlogbeat-*` | `@timestamp` |
| `filebeat-*` | `@timestamp` |

**Expected result in Kibana Discover:**

Search `winlogbeat-*` — filter for `event.code: 1` (process creation):
```
Example event visible:
  @timestamp: Aug 14, 2024 @ 14:32:00
  event.code: 1
  process.name: powershell.exe
  process.parent.name: winword.exe
  winlog.channel: Microsoft-Windows-Sysmon/Operational
```

Search `filebeat-*` — filter for `message: "Failed password"`:
```
Example event visible:
  @timestamp: Aug 14, 2024 @ 14:22:01
  message: Failed password for invalid user baduser from 127.0.0.1 port 54321 ssh2
  log.file.path: /var/log/auth.log
  host.name: ubuntu-lab
```

---

## Step 6 — Manual Log Analysis with grep/awk

**Extract failed SSH login source IPs:**
```bash
grep 'Failed password' /var/log/auth.log | awk '{print $11}' | sort | uniq -c | sort -rn
```

**Expected Output:**
```
      5 127.0.0.1
```
> In a real brute-force scenario, output would look like:
```
    342 203.0.113.45
     87 198.51.100.12
     23 192.0.2.88
```

**Breaking down the command:**
| Part | Explanation |
|------|------------|
| `grep 'Failed password'` | Filter only failed login lines |
| `awk '{print $11}'` | Extract field 11 (source IP in auth.log format) |
| `sort` | Sort IPs alphabetically |
| `uniq -c` | Count consecutive duplicates |
| `sort -rn` | Sort by count descending |

---

## Step 7 — Manual Correlation Rule (Written)

### Correlation Rule: SSH Brute Force Detection

```
RULE NAME:   Possible SSH Brute Force
DESCRIPTION: Detect potential brute-force attacks against SSH by identifying
             5 or more failed authentication attempts from the same source
             IP within a 5-minute sliding window.

IF:
  log.file.path = "/var/log/auth.log"
  AND message CONTAINS "Failed password"
  COUNT(source_ip) >= 5 WITHIN 5 minutes
  GROUP BY source_ip

THEN:
  Raise Alert: "Possible SSH Brute Force Detected"
  Severity:    High
  Tag:         T1110.001 (Brute Force: Password Guessing)
  Action:      Notify SOC Tier 1 analyst via email/PagerDuty

TUNING NOTES:
  - Adjust threshold from 5 to 10 for high-traffic jump hosts
  - Whitelist internal IP ranges for legitimate admin activity
  - Suppress if source IP matches IT admin CIDR blocks
```

### Kibana Aggregation Query Implementation

In Kibana → `Stack Management → Rules → Create rule → Elasticsearch query`:

```json
{
  "query": {
    "bool": {
      "filter": [
        { "term": { "log.file.path": "/var/log/auth.log" } },
        { "match": { "message": "Failed password" } },
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
```

**Alert Condition:** Trigger when `by_source_ip` bucket count > 0 (i.e., at least one IP has ≥ 5 failures in 5 min).

---

## Lab Challenge Solution — Second Filebeat Log Source

Add `/var/log/apache2/access.log` as a second Filebeat input:

```bash
# Install apache2 to generate access logs (if not present)
sudo apt-get install -y apache2

# Edit Filebeat config to add second input
sudo tee -a /etc/filebeat/filebeat.yml << 'EOF'

- type: filestream
  id: apache-access
  paths:
    - /var/log/apache2/access.log
  fields:
    log_type: apache_access
  fields_under_root: true
EOF

# Restart Filebeat
sudo systemctl restart filebeat

# Generate Apache access log events
curl -s http://localhost/ > /dev/null
curl -s http://localhost/nonexistent > /dev/null

# Verify in Kibana Discover: filter filebeat-* for fields.log_type: apache_access
```

**Expected Kibana Field Extraction:**
```
Fields visible in filebeat-* index:
  message:     "127.0.0.1 - - [14/Aug/2024:14:35:22 +0000] \"GET / HTTP/1.1\" 200 3456"
  log.file.path: /var/log/apache2/access.log
  fields.log_type: apache_access
```

---

[⬅ Setup](./setup.md) | [Grading Rubric ➡](./grading-rubric.md)
