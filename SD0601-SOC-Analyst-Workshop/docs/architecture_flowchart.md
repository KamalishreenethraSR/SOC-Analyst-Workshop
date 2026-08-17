# SD0601 SOC Analyst Training Laboratory — Complete Architecture Flowchart

![SD0601 Architecture Flowchart](/home/dev/.gemini/antigravity-ide/brain/5302987e-f962-4aab-9acc-b06405cdcff5/sd0601_architecture_flowchart_1786804612007.png)

---

## 🏛️ Architecture Breakdown by Layer

### Layer 1: Host Controller & Orchestration Engine
- **Command CLI**: `./sd0601.sh` (Linux / macOS / WSL2)
- **RAM Profile Engine**: Auto-detects free physical memory (`free -m`) and assigns profile:
  - **MINIMAL (8GB)**: ELK (Elasticsearch + Kibana)
  - **STANDARD (16GB)**: ELK + Wazuh + TheHive + Cortex
  - **FULL (32GB)**: ELK + Splunk + Wazuh + TheHive + Cortex + MISP
  - **INSTRUCTOR (64GB)**: Full stack with max JVM heap allocation

---

### Layer 2: Network Isolation Bridge (`soc-lab`)
- **Bridge Subnet**: `10.60.0.0/24`
- **Gateway**: `10.60.0.1`
- **Firewall Boundary**: Prevents external scanning, unauthorized internet outbound traffic, and protects corporate hosts.

---

### Layer 3: Endpoints & Attack Platforms

| Host / VM | IP Address | Operating System | Active Security & Telemetry Agents |
|-----------|------------|------------------|------------------------------------|
| **Windows 10 Victim** | `10.60.0.100` | Windows 10/11 Pro | Sysmon (Event ID 1/3/11), Winlogbeat, Wazuh Agent, Atomic Red Team |
| **Ubuntu Analyst** | `10.60.0.101` | Ubuntu 22.04 LTS | Filebeat (`auth.log`/`syslog`), `auditd` watch rules, Wazuh Agent |
| **Kali Attacker** | `10.60.0.200` | Kali Linux 2024.x | Nmap (Port Scanning), Hydra (SSH Brute Force), Red Team Scripts |

---

### Layer 4: Docker SOC Server Stack (`10.60.0.0/24`)

#### 1. SIEM Core Stack
- **Elasticsearch (`10.60.0.10:9200`)**: Primary document database for log storage and KQL queries.
- **Kibana (`10.60.0.11:5601`)**: Web UI for threat discovery, correlation alerting, and dashboards.
- **Logstash (`10.60.0.12:5044`)**: Ingestion pipeline for parsing complex logs into ECS schema.
- **Splunk Free (`10.60.0.20:8000`)**: Secondary SIEM for SPL search engineering, Zeek analytics, and alerts.

#### 2. EDR Platform (Wazuh Stack)
- **Wazuh Manager (`10.60.0.30:55000`)**: Central EDR server processing agent rules and active response commands.
- **Wazuh Dashboard (`10.60.0.31:8443`)**: Web UI for monitoring agent status, rootcheck, and file integrity events.

#### 3. Incident Response & Threat Intelligence Stack
- **TheHive 5 (`10.60.0.40:9000`)**: Case management platform for triaging incidents, assigning tasks, and organizing observables.
- **Cortex (`10.60.0.41:9001`)**: Automated observable enrichment engine running VirusTotal and AbuseIPDB analyzers.
- **MISP (`10.60.0.50:9443`)**: Threat intelligence platform storing and sharing structured IOCs with TLP markings.

---

## 🔄 Data Pipeline & Telemetry Flow

```
1. ENDPOINT TELEMETRY:
   Windows VM (Sysmon / Security)  ──> Winlogbeat ──> Elasticsearch (:9200) & Splunk (:9997)
   Ubuntu VM (auth.log / auditd)   ──> Filebeat   ──> Elasticsearch (:9200)
   Wazuh Agents (Win/Linux)        ──> Wazuh Manager (:1514)

2. SIEM CORRELATION & ALERTING:
   Elasticsearch / Wazuh Manager   ──> Fires Alerts ──> Ingested into TheHive 5 (:9000)

3. ENRICHMENT & THREAT SHARING:
   TheHive Observables             ──> Cortex Analyzers (:9001) ──> Enriched Results
   Investigated IOCs               ──> Exported to MISP (:9443) ──> TLP:AMBER Intelligence Sharing
```
