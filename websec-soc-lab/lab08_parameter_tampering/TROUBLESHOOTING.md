# Troubleshooting Guide — Lab 08 — Parameter Tampering

This guide addresses common issues encountered when deploying or running **Lab 08 — Parameter Tampering**.

---

## ❓ Common Issues & Solutions

### Issue 1: "Address already in use" Port Error
* **Symptom**: `OSError: [Errno 98] Address already in use` on port 5008, 6008, or 8008.
* **Solution**: Run `./stop.sh` inside `ubuntu_target` and `logviewer` to kill previous background processes:
  ```bash
  cd lab08_parameter_tampering/ubuntu_target && ./stop.sh
  cd ../logviewer && ./stop.sh
  ```

### Issue 2: Target Unreachable from Kali Attacker
* **Symptom**: `[FAIL] Target unreachable` when running `./attack.sh`.
* **Solution**: Run `./healthcheck.sh` on target to verify services are listening:
  ```bash
  cd lab08_parameter_tampering/ubuntu_target && ./healthcheck.sh
  ```

### Issue 3: Missing Security Events in SOC Viewer
* **Symptom**: SOC dashboard table is empty after attack script execution.
* **Solution**: Reset SQLite database and restart target services:
  ```bash
  cd lab08_parameter_tampering/ubuntu_target && ./reset.sh && ./start.sh
  ```
