# Lab 6.1 — Setup: Atomic Red Team Live-Fire Detection Drill

**Module:** [Module 6 — SOC Operations and Practical Labs](../../docs/06-soc-operations-and-practical-labs-incl-capstone.md)  
**Lab Guide:** [lab-6.1](../../labs/lab-6.1-atomic-red-team-live-fire-detection-drill.md)

---

## ⚡ Option A — Automated Setup (Recommended)

```bash
# 1. On Docker Host:
./sd0601.sh lab setup 6.1

# 2. On Windows VM:
setup.bat lab 6.1

# 3. Verify Readiness:
./sd0601.sh lab verify 6.1
```

---

## 🛠️ Option B — Manual Setup


## Prerequisites

> **This lab requires the full monitoring stack from Labs 2.1 and 5.1 to be operational.** Complete setup for both labs before proceeding.

| Component | Required From | Status Check |
|-----------|--------------|-------------|
| Sysmon | Lab 2.1 | `Get-Service Sysmon64` → Running |
| Winlogbeat | Lab 2.1 | `Get-Service winlogbeat` → Running |
| Filebeat (Linux) | Lab 2.1 | `systemctl status filebeat` → active |
| Elasticsearch + Kibana | Lab 2.1 | http://docker-host:5601 accessible |
| Wazuh Manager + Agent | Lab 5.1 | Agent shows Active in Dashboard |
| TheHive | Lab 4.1 | http://docker-host:9000 accessible |

---

## Step 1 — Full Stack Health Check

```bash
# Run from Docker host
echo "=== Elasticsearch ==="
curl -s -u elastic:changeme http://localhost:9200/_cluster/health | python3 -m json.tool | grep status

echo "=== Kibana ==="
curl -s http://localhost:5601/api/status | python3 -m json.tool | grep '"level"'

echo "=== Wazuh Manager ==="
curl -sk -u wazuh:wazuh https://localhost:55000/ | python3 -m json.tool | grep title

echo "=== TheHive ==="
curl -s http://localhost:9000/api/v1/status | python3 -m json.tool | grep status
```

**Expected: All services respond positively.**

---

## Step 2 — Install Atomic Red Team on Windows Victim VM

Run the PowerShell setup script from the assets:

```powershell
# Run from Administrator PowerShell on the Windows VM
# Copy and execute the setup script
.\atomic-red-team-setup.ps1
```

Or install manually:

```powershell
# Set execution policy
Set-ExecutionPolicy Bypass -Scope CurrentUser -Force

# Install Invoke-AtomicRedTeam
IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing)

# Install with all dependencies
Install-AtomicRedTeam -getAtomics -Force

# Verify installation
Invoke-AtomicTest T1059 -ShowDetails
# Expected: Shows details of Command and Scripting Interpreter tests
```

---

## Step 3 — Verify Atomic Red Team Works

```powershell
# Dry run first (CheckPrereqs only — does NOT execute attack)
Invoke-AtomicTest T1110 -TestNumbers 1 -CheckPrereqs
# Expected: Prints prereq status; should be Met/Already met

# Check T1053 (Scheduled Task)
Invoke-AtomicTest T1053.005 -TestNumbers 1 -CheckPrereqs

# Check T1059 (PowerShell)
Invoke-AtomicTest T1059.001 -TestNumbers 1 -CheckPrereqs
```

---

## Step 4 — SIEM Dashboard Pre-Verification

Before starting the live-fire exercise:

1. **Kibana:** Open a dashboard with real-time refresh (last 15 minutes, auto-refresh 10s)
2. **Wazuh Dashboard:** Open the Security events view filtered to the Windows victim VM
3. **TheHive:** Ensure a new case can be created (test with a dummy case, then delete)

---

## Verification Checklist

```
[ ] All monitoring stack services healthy (elastic, kibana, wazuh, thehive)
[ ] Sysmon running on Windows victim VM
[ ] Wazuh agent reporting from Windows victim VM (Active status in Dashboard)
[ ] Atomic Red Team installed: Invoke-AtomicTest T1059 -ShowDetails works
[ ] Invoke-AtomicTest T1110 -TestNumbers 1 -CheckPrereqs shows prereqs met
[ ] Kibana auto-refresh dashboard open and showing live events
[ ] Wazuh Dashboard showing recent events from Windows VM
[ ] TheHive is accessible and ready for case creation
[ ] Both student roles defined: Attacker/Operator and Defender/Analyst
[ ] Role swap timer ready (lab is divided into two halves)
```

---

[⬅ Back to Solutions Index](../README.md) | [Solution Guide ➡](./solution.md)
