# Lab 5.1 — Setup: Endpoint Detection, Threat Hunt, and Memory Triage

**Module:** [Module 5 — Endpoint and Network Monitoring](../../docs/05-endpoint-and-network-monitoring.md)  
**Lab Guide:** [lab-5.1](../../labs/lab-5.1-endpoint-detection-threat-hunt-and-memory-triage.md)

---

## ⚡ Option A — Automated Setup (Recommended)

```bash
# 1. On Docker Host:
./sd0601.sh lab setup 5.1

# 2. On Windows VM:
setup.bat lab 5.1

# 3. On Ubuntu VM:
./setup.sh lab 5.1

# 4. Verify Readiness:
./sd0601.sh lab verify 5.1
```

---

## 🛠️ Option B — Manual Setup


## Architecture Overview

```
Windows Victim VM                      Ubuntu VM
  Wazuh Agent ─────────────────────┐    Wazuh Agent ─────────────┐
  Sysmon (from Lab 2.1)            │    auditd                    │
  Sysinternals / PowerShell        │                              │
                                   ▼                              ▼
                         ┌──────────────────────────────────────────┐
                         │    Docker Host — Wazuh Manager Stack     │
                         │    Wazuh Manager   :55000               │
                         │    Wazuh Dashboard :443  (Kibana-based)  │
                         │    Elasticsearch   :9200                 │
                         └──────────────────────────────────────────┘

Offline (student laptop):
  Volatility3  ←  victim.mem  (instructor-provided memory image)
```

---

## Prerequisites

| Component | Minimum Spec |
|-----------|-------------|
| Docker Host | 8GB RAM, 40GB disk |
| Windows Victim VM | 4GB RAM, 40GB disk, Sysmon installed (Lab 2.1) |
| Ubuntu VM | 2GB RAM, 20GB disk, auditd available |
| Analyst laptop | Python 3.9+, 8GB RAM (for Volatility3) |
| memory image | `victim.mem` — instructor-provided (~4GB file) |

---

## Step 1 — Start Wazuh Manager Stack (Docker Host)

```bash
cd solutions/lab-5.1-endpoint-detection-threat-hunt-and-memory-triage/assets

docker compose up -d

# Monitor startup (~3 minutes)
docker compose ps
docker compose logs -f wazuh-manager

# Verify Wazuh Manager is up
curl -k -u admin:SecretPassword -s https://localhost:55000/ | python3 -m json.tool | grep '"title"'
# Expected: "title": "Wazuh API REST"
```

**Access URLs:**

| Service | URL | Credentials |
|---------|-----|-------------|
| Wazuh Dashboard | https://localhost:443 | `admin` / `SecretPassword` |
| Wazuh Manager API | https://localhost:55000 | `wazuh` / `wazuh` |

> **Note:** Accept the self-signed certificate warning in the browser.

---

## Step 2 — Install Wazuh Agent on Windows VM

**In Administrator PowerShell on the Windows VM:**

```powershell
# Download Wazuh agent MSI
$version = "4.8.0"
$url = "https://packages.wazuh.com/4.x/windows/wazuh-agent-${version}-1.msi"
Invoke-WebRequest -Uri $url -OutFile "C:\Temp\wazuh-agent.msi"

# Install with Manager IP
msiexec /i C:\Temp\wazuh-agent.msi `
  WAZUH_MANAGER="<DOCKER_HOST_IP>" `
  WAZUH_REGISTRATION_SERVER="<DOCKER_HOST_IP>" `
  WAZUH_REGISTRATION_PASSWORD="password" `
  /q

# Start the Wazuh agent service
NET START WazuhSvc

# Verify the agent is running
Get-Service WazuhSvc
# Expected: Status: Running

# Check the agent log
Get-Content "C:\Program Files (x86)\ossec-agent\ossec.log" -Tail 20
# Look for: "ossec: Agent started."
```

---

## Step 3 — Install Wazuh Agent on Ubuntu VM

```bash
# Add Wazuh repository
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo gpg --dearmor -o /usr/share/keyrings/wazuh.gpg
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" \
  | sudo tee /etc/apt/sources.list.d/wazuh.list

# Install
sudo apt-get update && sudo WAZUH_MANAGER="<DOCKER_HOST_IP>" apt-get install -y wazuh-agent

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
sudo systemctl status wazuh-agent
# Expected: active (running)
```

---

## Step 4 — Configure auditd on Ubuntu VM

```bash
# Install auditd if not present
sudo apt-get install -y auditd

# Copy lab auditd rules
sudo cp /path/to/assets/auditd-rules.conf /etc/audit/rules.d/soc-lab.rules

# Load rules immediately (without reboot)
sudo auditctl -R /etc/audit/rules.d/soc-lab.rules

# Verify rules loaded
sudo auditctl -l
# Expected: Multiple -w watch rules visible

# Restart auditd to make persistent
sudo systemctl restart auditd
sudo systemctl status auditd
```

---

## Step 5 — Install Volatility3 (Analyst Laptop)

```bash
# Python 3.9+ required
python3 --version

# Create virtual environment
python3 -m venv ~/vol3-env
source ~/vol3-env/bin/activate

# Install Volatility3
pip install volatility3

# Verify
vol.py --help | head -5
# Expected: Volatility 3 Framework ...

# Download symbol tables (required for Windows memory analysis)
# Option A: Download from Volatility GitHub releases
# Option B: Auto-download (Volatility3 will prompt on first use)
mkdir -p ~/.volatility3/symbols
# Symbols will be cached here automatically

# Place the instructor-provided memory image
cp /path/to/victim.mem ~/lab-evidence/

# Test basic command
vol.py -f ~/lab-evidence/victim.mem windows.info
```

---

## Verification Checklist

```
[ ] Wazuh Dashboard accessible at :443 with admin/SecretPassword
[ ] Windows VM Wazuh agent shows "Active" in Dashboard → Agents tab
[ ] Ubuntu VM Wazuh agent shows "Active" in Dashboard → Agents tab
[ ] auditd running on Ubuntu: systemctl status auditd
[ ] Lab auditd rules loaded: sudo auditctl -l shows watch rules
[ ] Volatility3 installed: vol.py --version returns 2.x
[ ] victim.mem present in ~/lab-evidence/ (check file size ~4GB)
[ ] vol.py -f victim.mem windows.info runs without error
```

---

[⬅ Back to Solutions Index](../README.md) | [Solution Guide ➡](./solution.md)
