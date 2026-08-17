# SD0601 — Troubleshooting & Diagnostic Guide

## Common Issues and Solutions

### 1. Elasticsearch Container Fails to Start (OutOfMemoryError)
**Cause:** Host has insufficient available RAM.
**Solution:**
```bash
./sd0601.sh install --profile minimal
```

### 2. Kibana status "Red" or "Yellow"
**Cause:** Elasticsearch is still initializing or heap is constrained.
**Solution:**
```bash
./sd0601.sh restart
./sd0601.sh health
```

### 3. Windows Winlogbeat cannot connect to Docker host
**Cause:** Firewall blocking port 9200 or 5044, or incorrect IP configured.
**Solution:**
Verify IP with `docker network inspect soc-lab` and update `winlogbeat.yml`.

### 4. Atomic Red Team test blocked
**Cause:** Test ID is not in `windows/art/approved-tests.json`.
**Solution:**
Only allowlisted safe training tests (T1110, T1053.005, T1059.001) are permitted in the lab environment.
