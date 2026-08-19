# Lab 10 — WAF Investigation

## 📌 Overview & Learning Objectives
**Compare allowed vs blocked requests, tune WAF signature rules, and analyze SOC logs.**

This lab provides an isolated environment to study **WAF_TUNING** security concepts, WAF detection mechanisms, and SOC log analysis.

---

## 💡 Concept Explanation

### What is Lab 10 — WAF Investigation?
WAF Rules Investigation & Tuning is the process of evaluating security logs to differentiate between legitimate user requests, false positives (benign requests mistakenly blocked), false negatives (attacks that bypassed rules), and true positives. SOC analysts use event logs to refine WAF signatures.

* **Example Request / Payload**: `Comparing Allowed Request A (benign search) vs Blocked Request B (attack string)`
* **Remediation Best Practice**: Continuously audit WAF block logs, refine detection regex patterns to minimize false positives, and combine WAF defenses with application-level security coding.

---

## 🏗️ Lab Architecture & Network Flow

```text
[Kali Attacker] ---> HTTP Request ---> [Python WAF Proxy] (Port 6010)
                                            |
                                            +--> Inspects Parameters & Headers
                                            +--> Logs to SQLite (security.db) & waf.log
                                            |
                                            v
                                  [Target Flask App] (Port 5010)
                                            |
                                            v
                                  [SOC Log Viewer UI] (Port 8010)
```

---

## 🚀 Quick Step-by-Step Execution Guide

### Step 1: Start Target Application & WAF Proxy `[UBUNTU TARGET]`
Open terminal on your Ubuntu system:
```bash
cd lab10_waf_investigation/ubuntu_target
./setup.sh
./start.sh
```
* **Expected Output**:
  ```text
  Application Port : http://0.0.0.0:5010
  WAF Proxy Port   : http://0.0.0.0:6010
  STATUS           : RUNNING
  ```

### Step 2: Start SOC Log Viewer `[UBUNTU TARGET]`
```bash
cd ../logviewer
./setup.sh
./start.sh
```
* Access Dashboard at: `http://SERVER_IP:8010`

### Step 3: Run Automated Attack Simulation `[KALI ATTACKER]`
Open terminal on Kali Linux:
```bash
cd lab10_waf_investigation/attacker_kali
./attack.sh
```
* **Expected Output**:
  ```text
  ========================================
   AUTOMATED ATTACK DEMONSTRATION
   Lab 10 — WAF Investigation
  ========================================
  [1/5] Checking target connectivity... [OK]
  [2/5] Sending baseline normal request... Status: 200
  [3/5] Sending automated training payload... Status: 200/403
  [4/5] Attack simulation sequence complete.
  [5/5] Check SOC Viewer to observe generated security logs.
  ```

### Step 4: Verify SOC Security Alert `[SOC VIEWER]`
Open browser at `http://localhost:8010` to observe logged security alerts.

---

## ❓ Review & Interview Practice Questions

### 1. Beginner Level
**Q:** What is the primary purpose of this lab?
**A:** To understand the mechanics of WAF_TUNING, demonstrate how WAF rules detect malicious requests, and analyze event logs in a SOC dashboard.

### 2. Technical Level
**Q:** How does the Python WAF identify this security event?
**A:** The WAF proxy intercepts incoming HTTP requests on port 6010, inspects URL query strings, request bodies, and headers against rule patterns, and logs detected anomalies into SQLite `security.db`.

### 3. SOC Analyst Level
**Q:** What key log fields should an analyst examine when investigating this incident?
**A:** Source IP address, Timestamp, HTTP Method, URL request path, Rule ID, WAF Action (ALLOWED/BLOCKED), and Severity level.

### 4. Scenario-Based Question
**Q:** If a similar event occurs in production, what immediate action should be taken?
**A:** Verify whether the request was blocked by WAF, check if the application processed the payload, inspect database/system integrity, and patch application code using standard remediation techniques.
