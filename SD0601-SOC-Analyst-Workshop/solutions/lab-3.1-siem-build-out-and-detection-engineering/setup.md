# Lab 3.1 — Setup: SIEM Build-Out and Detection Engineering

**Module:** [Module 3 — SIEM and Log Analysis](../../docs/03-siem-and-log-analysis.md)  
**Lab Guide:** [lab-3.1](../../labs/lab-3.1-siem-build-out-and-detection-engineering.md)

---

## ⚡ Option A — Automated Setup (Recommended)

```bash
# On Docker Host:
./sd0601.sh lab setup 3.1

# Verify Readiness:
./sd0601.sh lab verify 3.1
```

---

## 🛠️ Option B — Manual Setup

## Architecture Overview

```
Evidence Package (Instructor-provided)
  sample.evtx  ──────────┬──── Splunk (:8000) ──── Detections
  zeek-conn.log ─────────┤                          Dashboards
  zeek-dns.log  ─────────┘──── ELK (:5601) ──────── Alerts
                                   ▲
                             Docker Host
                             (Splunk + ELK)
```

---

## Prerequisites

| Component | Minimum Spec |
|-----------|-------------|
| Docker Host | 12GB RAM, 60GB disk (Splunk + ELK together are heavy) |
| Docker Engine | 24.x+ |
| Docker Compose | v2.x+ |
| Evidence package | `sample-evtx.zip` + `zeek-logs.tar.gz` from instructor |

---

## Step 1 — Start the Splunk + ELK Stack

```bash
cd solutions/lab-3.1-siem-build-out-and-detection-engineering/assets

docker compose up -d

# Monitor startup (takes 2–3 minutes)
docker compose ps
docker compose logs -f splunk      # Wait for "Splunk started"
docker compose logs -f elasticsearch  # Wait for green cluster

# Verify all services
curl -s http://localhost:9200/_cluster/health | python3 -m json.tool
curl -s -k http://admin:changeme@localhost:8000/services/server/info?output_mode=json | \
  python3 -m json.tool | grep '"version"'
```

**Access URLs:**

| Service | URL | Credentials |
|---------|-----|-------------|
| Splunk | http://localhost:8000 | `admin` / `changeme` |
| Elasticsearch | http://localhost:9200 | `elastic` / `changeme` |
| Kibana | http://localhost:5601 | `elastic` / `changeme` |

---

## Step 2 — Prepare Evidence Files

```bash
# Extract instructor-provided evidence package
mkdir -p /opt/lab-evidence
unzip sample-evtx.zip -d /opt/lab-evidence/
tar -xzf zeek-logs.tar.gz -d /opt/lab-evidence/

# Directory structure expected:
# /opt/lab-evidence/
# ├── Security-brute-force.evtx
# ├── Security-privesc.evtx
# ├── zeek/
# │   ├── conn.log
# │   └── dns.log
```

---

## Step 3 — Onboard Data into Splunk

```bash
# Copy EVTX into the Splunk container
docker cp /opt/lab-evidence/Security-brute-force.evtx splunk:/tmp/
docker cp /opt/lab-evidence/Security-privesc.evtx splunk:/tmp/

# Copy Zeek logs into Splunk container
docker cp /opt/lab-evidence/zeek/ splunk:/tmp/zeek/

# Ingest via Splunk CLI (or use the Add Data wizard in the UI)
docker exec splunk /opt/splunk/bin/splunk add oneshot \
  /tmp/Security-brute-force.evtx \
  -sourcetype WinEventLog:Security \
  -index main \
  -auth admin:changeme

docker exec splunk /opt/splunk/bin/splunk add oneshot \
  /tmp/zeek/conn.log \
  -sourcetype zeek:conn \
  -index zeek \
  -auth admin:changeme

docker exec splunk /opt/splunk/bin/splunk add oneshot \
  /tmp/zeek/dns.log \
  -sourcetype zeek:dns \
  -index zeek \
  -auth admin:changeme
```

---

## Step 4 — Create Splunk Indexes

In Splunk UI → Settings → Indexes → New Index:

| Index Name | Max Size |
|-----------|---------|
| `main` | 5GB |
| `zeek` | 5GB |

Or via CLI:
```bash
docker exec splunk /opt/splunk/bin/splunk add index zeek -auth admin:changeme
```

---

## Step 5 — Onboard Data into Kibana/ELK

```bash
# Copy files into the ELK Filebeat container for ingestion
# Or use Kibana's built-in file upload (Stack Management → Integrations → Upload a file)

# Option A — Kibana File Upload (easiest for EVTX CSV export)
# 1. Convert EVTX to CSV: python3 -c "import Evtx.Evtx as evtx ..."
# 2. Upload in Kibana → Integrations → Upload a file

# Option B — Filebeat custom log
# See lab-3.1 solution.md for Filebeat config snippet
```

---

## Verification Checklist

```
[ ] Splunk UI accessible at :8000 with admin/changeme
[ ] Kibana UI accessible at :5601 with elastic/changeme
[ ] Splunk index 'main' contains EVTX events (search: index=main | head 5)
[ ] Splunk index 'zeek' contains Zeek conn + dns events
[ ] Kibana index pattern for ELK data created
[ ] Both platforms show events with correct timestamps
```

---

[⬅ Back to Solutions Index](../README.md) | [Solution Guide ➡](./solution.md)
