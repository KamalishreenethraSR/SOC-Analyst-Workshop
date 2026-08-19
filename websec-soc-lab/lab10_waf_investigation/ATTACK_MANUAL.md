# Attack Manual — Lab 10 — WAF Investigation

This document details both the **Automated Method** and **Manual Method** for executing security test traffic against Lab 10 — WAF Investigation.

---

## 🎯 Target Configuration

* **Target URL (WAF Proxy)**: `http://127.0.0.1:6010`
* **Backend Application**: `http://127.0.0.1:5010`

---

## 🤖 Method 1: Automated Attack Simulation

Run the pre-packaged Python attack script from Kali Linux:

```bash
cd lab10_waf_investigation/attacker_kali
./attack.sh
```

### What `./attack.sh` Does:
1. Performs connectivity health check against `http://127.0.0.1:6010/health`.
2. Dispatches a normal baseline request (`GET /`).
3. Dispatches the automated training payload: `Comparing Allowed Request A (benign search) vs Blocked Request B (attack string)`.
4. Verifies WAF interception and response codes.

---

## 🖐️ Method 2: Manual Attack Execution

Students can manually send requests using `curl`:

### 1. Baseline Request
```bash
curl -i http://127.0.0.1:6010/
```
* **Expected Result**: `HTTP/1.1 200 OK`

### 2. Attack Simulation Payload
```bash
curl -i "http://127.0.0.1:6010/search?q=Comparing Allowed Request A (benign search) vs Blocked Request B (attack string)"
```
* **Expected Result**: WAF logs event `WAF_TUNING` and returns `HTTP 403 Forbidden` (or `200 OK` with logged security alert).
