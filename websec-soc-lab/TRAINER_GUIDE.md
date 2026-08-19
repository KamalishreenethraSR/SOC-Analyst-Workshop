# Trainer Guide

## Introduction

This guide provides instructors and lab facilitators with instructions for delivering hands-on web application security and SOC analysis training using this automated laboratory suite.

---

## Lab Architecture & Workflow

Every lab in this environment follows a unified workflow:

```
[Ubuntu Target: Flask App + Python WAF]
                ▲
                │ HTTP Requests & Attack Payloads
                ▼
[Kali Attacker: Python attack.py Script]
                │
                │ Logs Security Events to SQLite & security.log
                ▼
[Log Viewer: Flask SOC Dashboard UI]
```

---

## Teaching Strategy & Lesson Plans

### Module 1: HTTP Baseline & Reconnaissance (Labs 01 - 02)
- Focus on analyzing standard HTTP request structures, methods (GET/POST), status codes, and user-agent tracking.
- Teach students how baseline web traffic differs from automated scanner activity.

### Module 2: Injection & File Vulnerabilities (Labs 03 - 06)
- Explain SQL Injection, Cross-Site Scripting (XSS), Path Traversal, and Command Injection mechanics.
- Highlight how the Python WAF inspects request parameters, headers, and body payloads against signature rules before forwarding traffic to the application backend.

### Module 3: Authentication & Access Control (Labs 07 - 09)
- Cover Brute Force rate limiting, Parameter Tampering (IDOR), and Broken Access Control on admin routes.
- Demonstrate how SOC dashboards track login failures and unauthorized privilege escalation attempts.

### Module 4: WAF Rules & Log Analysis (Lab 10)
- Compare allowed vs. blocked requests.
- Discuss tuning detection signatures, handling false positives, and analyzing security logs.

---

## Classroom Management Commands

* Run full automated lab demonstration:
  ```bash
  ./run_lab.sh <LAB_NUMBER>
  ```
* Reset student lab environment:
  ```bash
  ./reset_all.sh
  ```
* Perform complete system validation:
  ```bash
  ./final_validation.sh
  ```
