# Docker SOC Server Stack - Deployment Guide

This directory contains the complete automated installation and configuration solution for deploying the `Docker_SOC_Server_Stack` on a fresh Ubuntu Server (22.04 LTS or 24.04 LTS).

---

## ⚡ Quick Start: How to Proceed

Follow this step-by-step procedure to deploy the stack on your target Ubuntu Server machine:

### Step 1: Transfer Files to the Target Server
Compress or directly transfer this directory to the target Ubuntu Server via `scp`, `rsync`, or an SFTP client:

```bash
# Example using scp (run from your analyst machine)
scp -r /home/redmon/Pictures/SOC-Analyst-Workshop user@<ubuntu-server-ip>:/home/user/
```

### Step 2: Execute the Entry Point Script
Log into your target Ubuntu Server via SSH, navigate to the transferred directory, and run the `run.sh` script:

```bash
# Log in via SSH
ssh user@<ubuntu-server-ip>

# Navigate and run the installer
cd /home/user/SOC-Analyst-Workshop
./run.sh
```

> [!NOTE]
> The `run.sh` script automatically escalates privileges using `sudo`. It will execute the main installation script (`install-docker-soc-server.sh`) with root privileges.

---

## 🏛️ Directory Structure After Installation

The installer provisions a dedicated directory at `/opt/Docker_SOC_Server_Stack/` with a clean, secured, and functional layout:

```text
/opt/Docker_SOC_Server_Stack/
│
├── docker-compose.yml     # Consolidated stack definition for all services
├── .env                  # Generated environment parameters and secure keys
│
├── config/               # Extensible configuration directory
├── scripts/              # Automated management scripts
│   ├── start.sh          # Start profile-specific services
│   ├── stop.sh           # Terminate stack containers (docker compose down)
│   ├── restart.sh        # Restart sequence (stop -> start)
│   ├── status.sh         # View running containers (docker compose ps)
│   ├── logs.sh           # Stream log trails (e.g. ./logs.sh wazuh-manager)
│   └── health-check.sh   # Run automated API status checks on all active nodes
│
├── data/                 # Host storage directories for persistent data
├── logs/                 # Active server log directories
├── backups/              # Space for scheduled snapshots and backups
└── certificates/         # Cortex/Wazuh SSL certificate stores
```

---

## 📈 Auto-Allocated RAM Profiles

During the requirement check phase, the script auto-detects the server's RAM and allocates the corresponding resource profile:

- **MINIMAL Profile** (Free RAM < 16 GB): Deploys only `Elasticsearch` and `Kibana`.
- **STANDARD Profile** (Free RAM 16 GB to 32 GB): Deploys `Elasticsearch`, `Kibana`, `Wazuh Manager`, `Wazuh Dashboard`, `Cassandra`, `TheHive`, and `Cortex`.
- **FULL Profile** (Free RAM >= 32 GB): Deploys the complete stack including `Splunk` and `MISP`.

---

## 🌐 Port Mappings and Integrations

| Service Name | Port | Protocol | Purpose |
|--------------|------|----------|---------|
| Elasticsearch API | `9200` | TCP | Log storage & Ingestion |
| Kibana UI | `5601` | TCP | Threat hunting dashboard |
| Splunk Web UI | `8000` | TCP | SPL searching console |
| Splunk HEC Ingest | `8088` | TCP | HTTP Event Collector ingest |
| Splunk Forwarder | `9997` | TCP | Heavy/Universal Forwarder input |
| Wazuh Agent Port | `1514` | TCP | Agent Log Ingestion |
| Wazuh Auth Port | `1515` | TCP | EDR Agent Enrollment |
| Wazuh Manager API | `55000` | TCP | EDR API management |
| Wazuh Dashboard | `8443` | TCP | Security analysis console (HTTPS) |
| TheHive 5 UI | `9000` | TCP | Incident Case Management |
| Cortex API | `9001` | TCP | Observable Enrichment Engine |
| MISP Web UI | `9443` | TCP | Threat Intelligence Portal (HTTPS) |

> [!IMPORTANT]
> **IP Binding & Public/External Access:**
> - Docker binds exposed ports to `0.0.0.0` (all interfaces) by default. This makes the services reachable over both the server's **Private IP** (internal network) and **Public IP** (external network/internet).
> - Ensure your network's cloud/host firewalls (e.g., AWS Security Groups, UFW, iptables) are configured to permit inbound TCP connections to the ports you want to access externally (e.g., `5601` for Kibana, `8443` for Wazuh, `8000` for Splunk, `9000` for TheHive).

---

## 🛠️ Post-Installation Management

Once the installation is complete, use the provided management scripts located in `/opt/Docker_SOC_Server_Stack/scripts/`:

* **Start the SOC stack**:
  ```bash
  /opt/Docker_SOC_Server_Stack/scripts/start.sh
  ```
* **Stop the SOC stack**:
  ```bash
  /opt/Docker_SOC_Server_Stack/scripts/stop.sh
  ```
* **Restart the SOC stack**:
  ```bash
  /opt/Docker_SOC_Server_Stack/scripts/restart.sh
  ```
* **Check status of containers**:
  ```bash
  /opt/Docker_SOC_Server_Stack/scripts/status.sh
  ```
* **Verify service health**:
  ```bash
  /opt/Docker_SOC_Server_Stack/scripts/health-check.sh
  ```
* **Stream container logs**:
  ```bash
  /opt/Docker_SOC_Server_Stack/scripts/logs.sh <service_name>
  ```

---

## 🔒 Security & Persistence
* All passwords and credentials (such as database credentials and API passwords) are randomly generated using `openssl` during configuration and stored securely in `/opt/Docker_SOC_Server_Stack/.env` (read-only by root).
* All Docker containers are configured with `restart: unless-stopped` restart policies, guaranteeing they will boot up automatically after an Ubuntu Server reboot.
* Log rotation is globally configured in `/etc/docker/daemon.json` to prevent Docker logs from consuming host disk space (`100MB` max size, `5` log files rotation limit).
