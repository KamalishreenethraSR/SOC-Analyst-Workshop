# SD0601 — Lab Matrix & Mapping

| Lab ID | Module | Title | Target VMs | Primary Tools | Datasets | ATT&CK Mapping | Deliverables |
|--------|--------|-------|------------|---------------|----------|----------------|--------------|
| **1.1** | 1 | ATT&CK Mapping & Ticket Triage | Student | Browser, Navigator, TheHive | Mock tickets, EML | T1566, T1059, T1053, T1078, T1021 | ATT&CK layer JSON, Triaged tickets |
| **2.1** | 2 | Log Pipeline: Endpoint to SIEM | Win/Ubuntu/SOC | Sysmon, Winlogbeat, Filebeat, ELK | EVTX, Sysmon JSON, syslog | T1110, T1059, T1003 | Working pipeline report |
| **3.1** | 3 | SIEM Build-Out & Detection Engineering | SOC | Splunk Free, Kibana KQL | EVTX, Zeek conn/dns logs | T1110, T1046, T1071 | SPL & KQL query packs, Dashboards |
| **4.1** | 4 | IOC Enrichment, YARA & Case Lifecycle | Win/SOC | TheHive 5, Cortex, MISP, YARA | Phishing EML, safe binary | T1566.001, T1204.002 | YARA rule, MISP event, TheHive case |
| **5.1** | 5 | EDR Hunt & Memory Triage | Win/Ubuntu/Analyst | Wazuh 4.8, auditd, Volatility 3 | Memory image, EVTX | T1053, T1055, T1003 | Threat hunt report, Volatility note |
| **6.1** | 6 | Atomic Red Team Live Drill | All | Atomic Red Team, Wazuh, SIEM | Synthetic telemetry | T1110, T1053.005, T1059.001 | Incident timeline, Drill summary |
| **Capstone** | Capstone | Operation SilentLedger | All | Full SOC Stack | SilentLedger evidence package | Full Kill-Chain (Stage 1-5) | Final Investigation Report |
