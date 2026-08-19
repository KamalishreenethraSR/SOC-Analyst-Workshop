# Attack Manual — Lab 03 — SQL Injection

This document details both the **Automated Method** and **Manual Method** for executing security test traffic against Lab 03 — SQL Injection.

---

## 🎯 Target Configuration

* **Target URL (WAF Proxy)**: `http://127.0.0.1:6003`
* **Backend Application**: `http://127.0.0.1:5003`

---

## 🤖 Method 1: Automated Attack Simulation

Run the pre-packaged Python attack script from Kali Linux:

```bash
cd lab03_sql_injection/attacker_kali
./attack.sh
```

### What `./attack.sh` Does:
1. Performs connectivity health check against `http://127.0.0.1:6003/health`.
2. Dispatches a normal baseline request (`GET /`).
3. Dispatches the automated training payload: `' OR '1'='1`.
4. Verifies WAF interception and response codes.

---

## 🖐️ Method 2: Manual Attack Execution

Students can manually send requests using `curl`:

### 1. Baseline Request
```bash
curl -i http://127.0.0.1:6003/
```
* **Expected Result**: `HTTP/1.1 200 OK`

### 2. Attack Simulation Payload
```bash
curl -i "http://127.0.0.1:6003/search?q=' OR '1'='1"
```
* **Expected Result**: WAF logs event `SQL_INJECTION` and returns `HTTP 403 Forbidden` (or `200 OK` with logged security alert).
