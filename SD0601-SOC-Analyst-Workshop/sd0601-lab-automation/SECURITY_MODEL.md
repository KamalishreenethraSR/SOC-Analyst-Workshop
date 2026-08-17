# SD0601 — Security Model & Safety Boundaries

## Important Safety Declaration
The SD0601 Lab Automation System is strictly designed for **isolated defensive cybersecurity education**.

### Safety Controls Enforced
1. **Network Isolation:** All lab services run inside a dedicated private Docker bridge network (`soc-lab` / `10.60.0.0/24`). Public exposure of management endpoints is strictly prevented.
2. **Safe Test Telemetry:** All attack scenarios use safe, synthetic log data, EICAR test strings, benign phishing templates, and pre-staged forensic evidence packages.
3. **Atomic Red Team Allowlist:** Live-fire testing via Atomic Red Team is restricted to explicitly allowlisted, safe technique numbers (`windows/art/approved-tests.json`).
4. **No Real Malware:** No active exploits, weaponized malware binaries, or credential harvesting payloads are generated or downloaded.
5. **No External Attacks:** No automated port scanning or network probing against external IP addresses is permitted.
