# Lab 01 — HTTP Baseline

## 📌 Overview & Learning Objectives
**Learn HTTP methods (GET, POST), headers, status codes, and baseline traffic logging.**

This lab provides an isolated environment to study **BASELINE_TRAFFIC** security concepts, WAF detection mechanisms, and SOC log analysis.

---

## 💡 Concept Explanation

### What is Lab 01 — HTTP Baseline?
HTTP Baseline Analysis involves understanding normal web application traffic patterns. Before you can detect attacks, you must know what benign, standard user requests look like. Web servers process HTTP GET and POST requests, respond with HTTP status codes (200 OK, 401 Unauthorized, 404 Not Found), and include User-Agent headers identifying browsers or devices.

* **Example Request / Payload**: `GET / HTTP/1.1 (Standard browser request)`
* **Remediation Best Practice**: Log all incoming HTTP requests with timestamps, client IP addresses, methods, URLs, and User-Agents for baseline modeling.

---

## 🏗️ Lab Architecture & Network Flow

```text
[Kali Attacker] ---> HTTP Request ---> [Python WAF Proxy] (Port 6001)
                                            |
                                            +--> Inspects Parameters & Headers
                                            +--> Logs to SQLite (security.db) & waf.log
                                            |
                                            v
                                  [Target Flask App] (Port 5001)
                                            |
                                            v
                                  [SOC Log Viewer UI] (Port 8001)
```

---

## 🚀 Quick Step-by-Step Execution Guide

### Step 1: Start Target Application & WAF Proxy `[UBUNTU TARGET]`
Open terminal on your Ubuntu system:
```bash
cd lab01_http_baseline/ubuntu_target
./setup.sh
./start.sh
```
* **Expected Output**:
  ```text
  Application Port : http://0.0.0.0:5001
  WAF Proxy Port   : http://0.0.0.0:6001
  STATUS           : RUNNING
  ```

### Step 2: Start SOC Log Viewer `[UBUNTU TARGET]`
```bash
cd ../logviewer
./setup.sh
./start.sh
```
* Access Dashboard at: `http://SERVER_IP:8001`

### Step 3: Run Automated Attack Simulation `[KALI ATTACKER]`
Open terminal on Kali Linux:
```bash
cd lab01_http_baseline/attacker_kali
./attack.sh
```
* **Expected Output**:
  ```text
  ========================================
   AUTOMATED ATTACK DEMONSTRATION
   Lab 01 — HTTP Baseline
  ========================================
  [1/5] Checking target connectivity... [OK]
  [2/5] Sending baseline normal request... Status: 200
  [3/5] Sending automated training payload... Status: 200/403
  [4/5] Attack simulation sequence complete.
  [5/5] Check SOC Viewer to observe generated security logs.
  ```

### Step 4: Verify SOC Security Alert `[SOC VIEWER]`
Open browser at `http://localhost:8001` to observe logged security alerts.

---

## ❓ Review & Interview Practice Questions

### 1. Beginner Level
**Q:** What is the primary purpose of this lab?
**A:** To understand the mechanics of BASELINE_TRAFFIC, demonstrate how WAF rules detect malicious requests, and analyze event logs in a SOC dashboard.

### 2. Technical Level
**Q:** How does the Python WAF identify this security event?
**A:** The WAF proxy intercepts incoming HTTP requests on port 6001, inspects URL query strings, request bodies, and headers against rule patterns, and logs detected anomalies into SQLite `security.db`.

### 3. SOC Analyst Level
**Q:** What key log fields should an analyst examine when investigating this incident?
**A:** Source IP address, Timestamp, HTTP Method, URL request path, Rule ID, WAF Action (ALLOWED/BLOCKED), and Severity level.

### 4. Scenario-Based Question
**Q:** If a similar event occurs in production, what immediate action should be taken?
**A:** Verify whether the request was blocked by WAF, check if the application processed the payload, inspect database/system integrity, and patch application code using standard remediation techniques.
