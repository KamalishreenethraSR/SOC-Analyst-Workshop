# 🛡️ Python Web Application Security + WAF + SOC Lab

A fully automated, beginner-friendly cybersecurity laboratory suite designed for hands-on **Web Application Security**, **Web Application Firewall (WAF) Rule Engineering**, and **Security Operations Center (SOC) Log Analysis**.

Written 100% in **Python** (`Flask`, `requests`, `sqlite3`), this suite contains **10 self-contained, independent training labs** with automated setup, attack simulations, and real-time dashboard visualizations.

---

## 📐 System Architecture

```text
                                +-----------------------------------+
                                |    Kali Linux Attacker Machine    |
                                |   (attacker_kali/attack.py)       |
                                +-----------------+-----------------+
                                                  |
                                                  | HTTP Requests / Attacks
                                                  v
                                +-----------------+-----------------+
                                |      Ubuntu Server Target         |
                                |  +-----------------------------+  |
                                |  | Python WAF Proxy            |  |
                                |  | (Port 6001 - 6010)          |  |
                                |  +--------------+--------------+  |
                                |                 |                 |
                                |       Inspects  | Forwards        |
                                |       Payloads  | Allowed Traffic |
                                |                 v                 |
                                |  +-----------------------------+  |
                                |  | Flask Target Web App        |  |
                                |  | (Port 5001 - 5010)          |  |
                                |  +-----------------------------+  |
                                |                 |                 |
                                |  Logs Security  | Stores Event    |
                                |  Events & Logs  | Data            |
                                |                 v                 |
                                |  +-----------------------------+  |
                                |  | SQLite DB (security.db) &   |  |
                                |  | JSON Security Log (waf.log) |  |
                                |  +--------------+--------------+  |
                                +-----------------|-----------------+
                                                  |
                                                  | Reads Alert Events
                                                  v
                                +-----------------+-----------------+
                                |     SOC Log Viewer Dashboard      |
                                |     (Port 8001 - 8010)            |
                                +-----------------------------------+
```

---

## 📂 Laboratory Catalog

Each lab focuses on a specific vulnerability category or security baseline:

| Lab ID | Lab Name | Target Port | WAF Port | SOC Dashboard Port | Core Security Focus |
|---|---|---|---|---|---|
| [`lab01`](file:///home/redmon/Public/Web-sec/python-websec-soc-lab/lab01_http_baseline/README.md) | **HTTP Baseline** | `5001` | `6001` | `8001` | HTTP verbs (GET, POST), headers, response codes, baseline modeling |
| [`lab02`](file:///home/redmon/Public/Web-sec/python-websec-soc-lab/lab02_reconnaissance/README.md) | **Reconnaissance** | `5002` | `6002` | `8002` | Automated scanners (Nmap, Nikto), User-Agent signatures, path probing |
| [`lab03`](file:///home/redmon/Public/Web-sec/python-websec-soc-lab/lab03_sql_injection/README.md) | **SQL Injection** | `5003` | `6003` | `8003` | Unsanitized SQLite queries, WAF SQLi signature rules, parameterized queries |
| [`lab04`](file:///home/redmon/Public/Web-sec/python-websec-soc-lab/lab04_reflected_xss/README.md) | **Reflected XSS** | `5004` | `6004` | `8004` | Unescaped HTML parameters, `<script>` tags, contextual HTML encoding |
| [`lab05`](file:///home/redmon/Public/Web-sec/python-websec-soc-lab/lab05_path_traversal/README.md) | **Path Traversal** | `5005` | `6005` | `8005` | File parameter manipulation (`../`), path normalization, canonical jailing |
| [`lab06`](file:///home/redmon/Public/Web-sec/python-websec-soc-lab/lab06_command_injection/README.md) | **Command Injection** | `5006` | `6006` | `8006` | System shell operators (`;&|`), command sandboxing, whitelist enforcement |
| [`lab07`](file:///home/redmon/Public/Web-sec/python-websec-soc-lab/lab07_bruteforce/README.md) | **Brute Force** | `5007` | `6007` | `8007` | Automated credential guessing, rate limiting, login failure thresholds |
| [`lab08`](file:///home/redmon/Public/Web-sec/python-websec-soc-lab/lab08_parameter_tampering/README.md) | **Parameter Tampering** | `5008` | `6008` | `8008` | Insecure Direct Object Reference (IDOR), numeric ID audit, server authorization |
| [`lab09`](file:///home/redmon/Public/Web-sec/python-websec-soc-lab/lab09_access_control/README.md) | **Access Control** | `5009` | `6009` | `8009` | Unauthenticated access to `/admin` routes, Bearer token audit, RBAC middleware |
| [`lab10`](file:///home/redmon/Public/Web-sec/python-websec-soc-lab/lab10_waf_investigation/README.md) | **WAF Investigation** | `5010` | `6010` | `8010` | Allowed vs blocked traffic analysis, false positive tuning, SOC log auditing |

---

## ⚡ Quick Start Command Guide

### 1. Environment Setup (Run Once)
```bash
./setup_all.sh
```
This automatically verifies Python, installs required packages (`flask`, `requests`), and initializes database schemas and logs across all 10 labs.

### 2. Launching & Testing a Single Lab (e.g. Lab 03 — SQL Injection)
```bash
./run_lab.sh 03
```
This single command automatically:
1. Starts the Target Application (`http://localhost:5003`)
2. Starts the Python WAF Proxy (`http://localhost:6003`)
3. Starts the SOC Log Viewer (`http://localhost:8003`)
4. Runs the Kali Attack Simulation (`attack.py`)
5. Verifies WAF interception and SOC event logging

### 3. Master Management Controls
* **Start All Labs**: `./start_all.sh`
* **Stop All Labs**: `./stop_all.sh`
* **Check Status**: `./status_all.sh`
* **Health Check**: `./healthcheck_all.sh`
* **Validate Complete Lab Suite**: `./final_validation.sh`
* **Reset Databases & Logs**: `./reset_all.sh`

---

## 📖 Comprehensive Manuals & Documentation Links

* [MASTER_SETUP.md](file:///home/redmon/Public/Web-sec/python-websec-soc-lab/MASTER_SETUP.md) — System requirements, installation, and network configuration.
* [WINDOWS_WSL_SETUP.md](file:///home/redmon/Public/Web-sec/python-websec-soc-lab/WINDOWS_WSL_SETUP.md) — Running the lab environment in Windows WSL2 (Ubuntu / Kali).
* [TRAINER_GUIDE.md](file:///home/redmon/Public/Web-sec/python-websec-soc-lab/TRAINER_GUIDE.md) — Instructor guidelines, lesson plans, and classroom management.
* [STUDENT_GUIDE.md](file:///home/redmon/Public/Web-sec/python-websec-soc-lab/STUDENT_GUIDE.md) — Student pathways and hands-on exercises.
