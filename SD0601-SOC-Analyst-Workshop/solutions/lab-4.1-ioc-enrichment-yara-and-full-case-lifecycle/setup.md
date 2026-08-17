# Lab 4.1 — Setup: IOC Enrichment, YARA, and Full Case Lifecycle

**Module:** [Module 4 — Threat Intelligence and Incident Response Frameworks](../../docs/04-threat-intelligence-and-incident-response-frameworks.md)  
**Lab Guide:** [lab-4.1](../../labs/lab-4.1-ioc-enrichment-yara-and-full-case-lifecycle.md)

---

## ⚡ Option A — Automated Setup (Recommended)

```bash
# On Docker Host:
./sd0601.sh lab setup 4.1

# Verify Readiness:
./sd0601.sh lab verify 4.1
```

---

## 🛠️ Option B — Manual Setup

## Architecture Overview

```
Student Workstation
  sample.exe ─────────────────────── SHA256 → VirusTotal API
  phishing.eml ─────────────────────  IP/URL → AbuseIPDB
  file hash ────────────────────────  Hash → VT + MISP event

                 Docker Host
  ┌───────────────────────────────────────┐
  │  TheHive (:9000)   Case Management    │
  │  Cortex   (:9001)  Analyzer Engine   │
  │  MISP     (:443)   Threat Intel      │
  │  Cassandra (DB)    TheHive Storage   │
  │  Elasticsearch     TheHive + MISP ES │
  └───────────────────────────────────────┘
```

---

## Prerequisites

| Component | Minimum Spec |
|-----------|-------------|
| Docker Host | 8GB RAM, 40GB disk |
| Sample files | `sample.exe` (EICAR-style), `phishing.eml` — provided by instructor |
| Internet access | Required for VirusTotal, AbuseIPDB API calls |
| VirusTotal API key | Free tier (sign up at https://www.virustotal.com) |
| AbuseIPDB API key | Free tier (sign up at https://www.abuseipdb.com) |

---

## Step 1 — Start TheHive + Cortex + MISP Stack

```bash
cd solutions/lab-4.1-ioc-enrichment-yara-and-full-case-lifecycle/assets

docker compose up -d

# Wait 3–5 minutes for all services to initialise
docker compose ps

# Verify TheHive
curl -s http://localhost:9000/api/v1/status | python3 -m json.tool | grep '"status"'
# Expected: "status": "Ok"

# Verify MISP
curl -sk https://localhost/users/login | grep -i "misp"
# Expected: MISP login page HTML
```

**Access URLs:**

| Service | URL | Default Credentials |
|---------|-----|---------------------|
| TheHive | http://localhost:9000 | `admin@thehive.local` / `secret` |
| Cortex | http://localhost:9001 | `admin` / `secret` (create on first login) |
| MISP | https://localhost | `admin@admin.test` / `admin` (change on first login) |

---

## Step 2 — Configure Cortex Analyzers

1. Open Cortex at http://localhost:9001
2. Create an organization → Add user
3. Navigate to **Analyzers** tab
4. Enable the following analyzers and add your API keys:
   - `VirusTotal_GetReport_3_0` — add your VT API key
   - `AbuseIPDB` — add your AbuseIPDB API key
   - `File_Info_2_0` — no API key needed (file metadata)
   - `MISP_2_0` — configure with MISP URL and API key

---

## Step 3 — Connect TheHive to Cortex

1. Open TheHive → Admin → Platform management → Connectors
2. Add Cortex server:
   - URL: `http://cortex:9001`
   - API Key: (generate in Cortex → Users → API key)
3. Test connection — expect green checkmark

---

## Step 4 — Install YARA on Student Workstation

```bash
# Ubuntu/Debian
sudo apt-get install -y yara

# Verify
yara --version
# Expected: 4.x.x

# macOS
brew install yara

# Windows (PowerShell — requires YARA binary in PATH)
# Download from https://github.com/VirusTotal/yara/releases
```

---

## Step 5 — Prepare Evidence Files

```bash
# Place instructor-provided files:
mkdir -p ~/lab-evidence
cp /path/to/instructor/sample.exe ~/lab-evidence/
cp /path/to/instructor/phishing.eml ~/lab-evidence/

# Create EICAR test file if instructor binary not available
echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' \
  > ~/lab-evidence/sample.exe
```

---

## Verification Checklist

```
[ ] TheHive accessible at :9000 and admin login works
[ ] Cortex accessible at :9001 and analyzers tab shows VT + AbuseIPDB
[ ] MISP accessible at :443, admin login works, default org created
[ ] TheHive ↔ Cortex connector shows green
[ ] YARA installed: yara --version returns 4.x
[ ] sample.exe and phishing.eml present in ~/lab-evidence/
[ ] VirusTotal and AbuseIPDB API keys added to Cortex analyzers
```

---

[⬅ Back to Solutions Index](../README.md) | [Solution Guide ➡](./solution.md)
