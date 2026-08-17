# Lab 2.1 — Setup: Log Pipeline: Endpoint to SIEM

**Module:** [Module 2 — Security Monitoring and Log Management](../../docs/02-security-monitoring-and-log-management.md)  
**Lab Guide:** [lab-2.1](../../labs/lab-2.1-log-pipeline-endpoint-to-siem.md)

---

## ⚡ Option A — Automated Setup (Recommended)

If using the **SD0601 Automation Platform**:

```bash
# 1. On Docker Host (Instructor):
./sd0601.sh lab setup 2.1

# 2. On Windows VM (Student):
setup.bat lab 2.1

# 3. On Ubuntu VM (Student):
./setup.sh lab 2.1

# 4. Verify Lab 2.1 Readiness:
./sd0601.sh lab verify 2.1
```

---

## 🛠️ Option B — Manual Step-by-Step Setup


## Architecture Overview

```
Windows 10/11 VM                Ubuntu 22.04 VM
   Sysmon ──────────────┐          Filebeat ──────────────┐
   Winlogbeat ──────────┤          /var/log/auth.log       │
   (Security + Sysmon   │          /var/log/syslog         │
    channels)           │                                  │
                        ▼                                  ▼
               ┌─────────────────────────────────────────────┐
               │       Docker Host — ELK Stack               │
               │   Elasticsearch :9200  Kibana :5601         │
               └─────────────────────────────────────────────┘
```

---

## Prerequisites

| Component | Minimum Spec |
|-----------|-------------|
| Windows 10/11 VM | 4GB RAM, 40GB disk, PowerShell 5.1+ |
| Ubuntu 22.04 VM | 2GB RAM, 20GB disk |
| Docker Host | 8GB RAM, 40GB disk, Docker Engine 24.x, Docker Compose v2 |
| Network | All three hosts must reach Docker host on ports 9200, 5601 |

---

## Step 1 — Start the ELK Stack (Docker Host)

```bash
# Navigate to the lab assets directory
cd /path/to/solutions/lab-2.1-log-pipeline-endpoint-to-siem/assets

# Start Elasticsearch + Kibana
docker compose up -d

# Verify both containers are healthy
docker compose ps
# Expected:
#   elasticsearch   running   0.0.0.0:9200->9200/tcp
#   kibana          running   0.0.0.0:5601->5601/tcp

# Wait until Elasticsearch is green (~60 seconds)
curl -s http://localhost:9200/_cluster/health | python3 -m json.tool
# Expected: "status": "green" or "yellow"

# Wait until Kibana is ready
curl -s http://localhost:5601/api/status | python3 -m json.tool | grep '"level"'
# Expected: "level": "available"
```

**Access URLs:**

| Service | URL | Credentials |
|---------|-----|-------------|
| Elasticsearch | http://\<docker-host-ip\>:9200 | `elastic` / `changeme` |
| Kibana | http://\<docker-host-ip\>:5601 | `elastic` / `changeme` |

---

## Step 2 — Windows VM: Install Sysmon

Run the following in an **Administrator PowerShell** session:

```powershell
# Download Sysmon
$url = "https://download.sysinternals.com/files/Sysmon.zip"
Invoke-WebRequest -Uri $url -OutFile C:\Tools\Sysmon.zip
Expand-Archive C:\Tools\Sysmon.zip -DestinationPath C:\Tools\Sysmon

# Download SwiftOnSecurity Sysmon config
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml" `
  -OutFile C:\Tools\Sysmon\sysmonconfig.xml

# Install Sysmon with the config
# (The sysmonconfig.xml asset is also provided in this lab's assets/ directory)
C:\Tools\Sysmon\Sysmon64.exe -accepteula -i C:\Tools\Sysmon\sysmonconfig.xml

# Verify Sysmon service is running
Get-Service Sysmon64
# Expected: Status: Running
```

---

## Step 3 — Windows VM: Install and Configure Winlogbeat

```powershell
# Download Winlogbeat (match Elasticsearch version — 8.x)
$url = "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-8.13.0-windows-x86_64.zip"
Invoke-WebRequest -Uri $url -OutFile C:\Tools\winlogbeat.zip
Expand-Archive C:\Tools\winlogbeat.zip -DestinationPath "C:\Program Files\Winlogbeat"
Rename-Item "C:\Program Files\Winlogbeat\winlogbeat-*" "C:\Program Files\Winlogbeat\winlogbeat"

# Copy the lab-provided configuration
Copy-Item "<assets_dir>\winlogbeat.yml" "C:\Program Files\Winlogbeat\winlogbeat\winlogbeat.yml"

# Test configuration
cd "C:\Program Files\Winlogbeat\winlogbeat"
.\winlogbeat.exe test config -c winlogbeat.yml -e

# Install and start Winlogbeat as a Windows service
.\install-service-winlogbeat.ps1
Start-Service winlogbeat
Get-Service winlogbeat
# Expected: Status: Running
```

---

## Step 4 — Ubuntu VM: Install and Configure Filebeat

```bash
# Add Elastic APT repository
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/elastic-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" \
  | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

# Install Filebeat
sudo apt-get update && sudo apt-get install -y filebeat

# Copy lab configuration
sudo cp /path/to/assets/filebeat.yml /etc/filebeat/filebeat.yml

# Enable filebeat service
sudo systemctl enable filebeat

# Test configuration
sudo filebeat test config -e

# Start Filebeat
sudo systemctl start filebeat
sudo systemctl status filebeat
# Expected: active (running)
```

---

## Step 5 — Verification Checklist

```
[ ] ELK stack running: elasticsearch green, kibana available
[ ] Sysmon service running on Windows VM (Get-Service Sysmon64)
[ ] Winlogbeat service running on Windows VM (Get-Service winlogbeat)
[ ] Filebeat service running on Ubuntu VM (systemctl status filebeat)
[ ] Elasticsearch index 'winlogbeat-*' visible (curl localhost:9200/_cat/indices)
[ ] Elasticsearch index 'filebeat-*' visible
[ ] Kibana index patterns created for both indices
[ ] Events appear in Kibana Discover for both Windows and Linux sources
```

---

[⬅ Back to Solutions Index](../README.md) | [Solution Guide ➡](./solution.md)
