# Troubleshooting Guide — Lab 04 — Reflected XSS

This guide addresses common issues encountered when deploying or running **Lab 04 — Reflected XSS**.

---

## ❓ Common Issues & Solutions

### Issue 1: "Address already in use" Port Error
* **Symptom**: `OSError: [Errno 98] Address already in use` on port 5004, 6004, or 8004.
* **Solution**: Run `./stop.sh` inside `ubuntu_target` and `logviewer` to kill previous background processes:
  ```bash
  cd lab04_reflected_xss/ubuntu_target && ./stop.sh
  cd ../logviewer && ./stop.sh
  ```

### Issue 2: Target Unreachable from Kali Attacker
* **Symptom**: `[FAIL] Target unreachable` when running `./attack.sh`.
* **Solution**: Run `./healthcheck.sh` on target to verify services are listening:
  ```bash
  cd lab04_reflected_xss/ubuntu_target && ./healthcheck.sh
  ```

### Issue 3: Missing Security Events in SOC Viewer
* **Symptom**: SOC dashboard table is empty after attack script execution.
* **Solution**: Reset SQLite database and restart target services:
  ```bash
  cd lab04_reflected_xss/ubuntu_target && ./reset.sh && ./start.sh
  ```
