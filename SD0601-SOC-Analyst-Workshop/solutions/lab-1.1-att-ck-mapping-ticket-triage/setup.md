# Lab 1.1 — Setup: ATT&CK Mapping & Ticket Triage

**Module:** [Module 1 — Introduction to SOC and Threat Landscape](../../docs/01-introduction-to-soc-and-threat-landscape.md)  
**Lab Guide:** [lab-1.1](../../labs/lab-1.1-att-ck-mapping-and-ticket-triage.md)

---

## ⚡ Option A — Automated Setup (Recommended)

```bash
# On Docker Host:
./sd0601.sh lab setup 1.1

# Verify Readiness:
./sd0601.sh lab verify 1.1
```

---

## 🛠️ Option B — Manual Setup

## Prerequisites

This lab is **entirely browser-based** — no local software installation is required for the core exercises. Ensure the following are available:

### Tools Required

| Tool | Access | Notes |
|------|--------|-------|
| MITRE ATT&CK Navigator | https://mitre-attack.github.io/attack-navigator/ | Web — no login needed |
| TheHive (demo instance) | Instructor-provided URL or local Docker | See below for Docker option |
| osTicket (optional alt.) | Instructor-provided URL | Alternative ticketing demo |
| Modern web browser | Chrome / Firefox / Edge | Required for ATT&CK Navigator |

### Hardware Requirements

- Any modern laptop/desktop with internet access
- No VMs needed for this lab

---

## Option A — Browser-Only (Recommended for Lab 1.1)

No installation needed. Open ATT&CK Navigator directly at:

```
https://mitre-attack.github.io/attack-navigator/
```

For TheHive, use the instructor-provided demo instance URL.

---

## Option B — Local TheHive via Docker

If running a self-hosted TheHive for ticket triage:

### Prerequisites
- Docker Engine 24.x+
- Docker Compose v2.x+
- 4GB+ free RAM on Docker host

### Start TheHive Stack

```bash
# Clone the lab assets
cd /opt/soc-lab

# Start TheHive + Cassandra + Elasticsearch
docker compose -f ../solutions/lab-1.1-att-ck-mapping-ticket-triage/assets/docker-compose-thehive.yml up -d

# Wait ~60 seconds for services to initialise
docker compose -f ../solutions/lab-1.1-att-ck-mapping-ticket-triage/assets/docker-compose-thehive.yml ps
```

### Access URLs

| Service | URL | Default Credentials |
|---------|-----|---------------------|
| TheHive | http://localhost:9000 | `admin@thehive.local` / `secret` |

### Verify Health

```bash
curl -s http://localhost:9000/api/v1/status | python3 -m json.tool
# Expected: {"status":"Ok", ...}
```

---

## ATT&CK Navigator — First-Time Setup

1. Navigate to https://mitre-attack.github.io/attack-navigator/
2. Click **"Create New Layer"** → **"Enterprise ATT&CK"** (latest version)
3. Name the layer: `Lab1-<YourStudentID>` (top-left name field)
4. Keep the matrix view as-is (all tactics visible)

### Export a Layer

After completing the mapping:
1. Click the **download** icon (⬇) in the toolbar
2. Select **"Layer"** → **"Download"**
3. Save as `Lab1-<StudentID>.json`

---

## Pre-Lab Verification Checklist

```
[ ] ATT&CK Navigator opens in browser and shows Enterprise matrix
[ ] Layer creation works (can name and save a layer)
[ ] TheHive/osTicket is accessible (demo URL or local Docker)
[ ] Student has Student ID for layer naming
[ ] Mock ticket queue (mock-tickets.md or instructor-loaded tickets) is available
```

---

[⬅ Back to Solutions Index](../README.md) | [Solution Guide ➡](./solution.md)
