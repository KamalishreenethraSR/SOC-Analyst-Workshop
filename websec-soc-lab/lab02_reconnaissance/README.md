# Lab 02 — Reconnaissance

## 📌 Overview & Learning Objectives
**Detect automated vulnerability scanners, endpoint enumeration, and suspicious User-Agents.**

This lab provides an isolated environment to study **RECONNAISSANCE** security concepts, WAF detection mechanisms, and SOC log analysis.

---

## 💡 Concept Explanation

### What is Lab 02 — Reconnaissance?
Reconnaissance is the initial phase of an attack cycle where adversaries probe a target web application to discover endpoints, sensitive files, server versions, and potential vulnerabilities. Automated security scanners like Nmap, Nikto, or SQLmap leave distinct signatures in User-Agent headers and URL paths.

* **Example Request / Payload**: `User-Agent: Nmap Scripting Engine / Nikto`
* **Remediation Best Practice**: Block automated scanner User-Agents at the WAF level and rate-limit rapid multi-endpoint path probing.

---

## 🏗️ Lab Architecture & Network Flow

```text
[Kali Attacker] ---> HTTP Request ---> [Python WAF Proxy] (Port 6002)
                                            |
                                            +--> Inspects Parameters & Headers
                                            +--> Logs to SQLite (security.db) & waf.log
                                            |
                                            v
                                  [Target Flask App] (Port 5002)
                                            |
                                            v
                                  [SOC Log Viewer UI] (Port 8002)
```

---

## 🚀 Quick Step-by-Step Execution Guide

### Step 1: Start Target Application & WAF Proxy `[UBUNTU TARGET]`
Open terminal on your Ubuntu system:
```bash
cd lab02_reconnaissance/ubuntu_target
./setup.sh
./start.sh
```
* **Expected Output**:
  ```text
  Application Port : http://0.0.0.0:5002
  WAF Proxy Port   : http://0.0.0.0:6002
  STATUS           : RUNNING
  ```

### Step 2: Start SOC Log Viewer `[UBUNTU TARGET]`
```bash
cd ../logviewer
./setup.sh
./start.sh
```
* Access Dashboard at: `http://SERVER_IP:8002`

### Step 3: Run Automated Attack Simulation `[KALI ATTACKER]`
Open terminal on Kali Linux:
```bash
cd lab02_reconnaissance/attacker_kali
./attack.sh
```
* **Expected Output**:
  ```text
  ========================================
   AUTOMATED ATTACK DEMONSTRATION
   Lab 02 — Reconnaissance
  ========================================
  [1/5] Checking target connectivity... [OK]
  [2/5] Sending baseline normal request... Status: 200
  [3/5] Sending automated training payload... Status: 200/403
  [4/5] Attack simulation sequence complete.
  [5/5] Check SOC Viewer to observe generated security logs.
  ```

### Step 4: Verify SOC Security Alert `[SOC VIEWER]`
Open browser at `http://localhost:8002` to observe logged security alerts.

---

## ❓ Review & Interview Practice Questions

### 1. Beginner Level
**Q:** What is the primary purpose of this lab?
**A:** To understand the mechanics of RECONNAISSANCE, demonstrate how WAF rules detect malicious requests, and analyze event logs in a SOC dashboard.

### 2. Technical Level
**Q:** How does the Python WAF identify this security event?
**A:** The WAF proxy intercepts incoming HTTP requests on port 6002, inspects URL query strings, request bodies, and headers against rule patterns, and logs detected anomalies into SQLite `security.db`.

### 3. SOC Analyst Level
**Q:** What key log fields should an analyst examine when investigating this incident?
**A:** Source IP address, Timestamp, HTTP Method, URL request path, Rule ID, WAF Action (ALLOWED/BLOCKED), and Severity level.

### 4. Scenario-Based Question
**Q:** If a similar event occurs in production, what immediate action should be taken?
**A:** Verify whether the request was blocked by WAF, check if the application processed the payload, inspect database/system integrity, and patch application code using standard remediation techniques.
