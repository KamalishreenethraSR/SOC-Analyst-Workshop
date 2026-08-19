# Attack Manual — Lab 06 — Command Injection

This document details both the **Automated Method** and **Manual Method** for executing security test traffic against Lab 06 — Command Injection.

---

## 🎯 Target Configuration

* **Target URL (WAF Proxy)**: `http://127.0.0.1:6006`
* **Backend Application**: `http://127.0.0.1:5006`

---

## 🤖 Method 1: Automated Attack Simulation

Run the pre-packaged Python attack script from Kali Linux:

```bash
cd lab06_command_injection/attacker_kali
./attack.sh
```

### What `./attack.sh` Does:
1. Performs connectivity health check against `http://127.0.0.1:6006/health`.
2. Dispatches a normal baseline request (`GET /`).
3. Dispatches the automated training payload: `127.0.0.1; whoami`.
4. Verifies WAF interception and response codes.

---

## 🖐️ Method 2: Manual Attack Execution

Students can manually send requests using `curl`:

### 1. Baseline Request
```bash
curl -i http://127.0.0.1:6006/
```
* **Expected Result**: `HTTP/1.1 200 OK`

### 2. Attack Simulation Payload
```bash
curl -i "http://127.0.0.1:6006/search?q=127.0.0.1; whoami"
```
* **Expected Result**: WAF logs event `COMMAND_INJECTION` and returns `HTTP 403 Forbidden` (or `200 OK` with logged security alert).
