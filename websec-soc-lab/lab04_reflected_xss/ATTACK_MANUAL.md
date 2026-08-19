# Attack Manual — Lab 04 — Reflected XSS

This document details both the **Automated Method** and **Manual Method** for executing security test traffic against Lab 04 — Reflected XSS.

---

## 🎯 Target Configuration

* **Target URL (WAF Proxy)**: `http://127.0.0.1:6004`
* **Backend Application**: `http://127.0.0.1:5004`

---

## 🤖 Method 1: Automated Attack Simulation

Run the pre-packaged Python attack script from Kali Linux:

```bash
cd lab04_reflected_xss/attacker_kali
./attack.sh
```

### What `./attack.sh` Does:
1. Performs connectivity health check against `http://127.0.0.1:6004/health`.
2. Dispatches a normal baseline request (`GET /`).
3. Dispatches the automated training payload: `<script>alert('XSS')</script>`.
4. Verifies WAF interception and response codes.

---

## 🖐️ Method 2: Manual Attack Execution

Students can manually send requests using `curl`:

### 1. Baseline Request
```bash
curl -i http://127.0.0.1:6004/
```
* **Expected Result**: `HTTP/1.1 200 OK`

### 2. Attack Simulation Payload
```bash
curl -i "http://127.0.0.1:6004/search?q=<script>alert('XSS')</script>"
```
* **Expected Result**: WAF logs event `XSS` and returns `HTTP 403 Forbidden` (or `200 OK` with logged security alert).
