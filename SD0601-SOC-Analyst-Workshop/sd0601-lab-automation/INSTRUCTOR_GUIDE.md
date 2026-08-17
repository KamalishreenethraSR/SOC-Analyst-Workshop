# SD0601 — Instructor Guide

## Overview

This guide provides operational instructions for orchestrating the SD0601 course using the `./sd0601.sh` automation CLI.

---

## Daily Workflow

### Morning Setup

```bash
# 1. Start Docker SOC services
./sd0601.sh start

# 2. Check service health
./sd0601.sh health

# 3. Setup today's lab (e.g. Day 2 / Lab 2.1)
./sd0601.sh day setup 2

# 4. Verify lab readiness
./sd0601.sh lab verify 2.1
```

### Lab Execution

1. Have students run `setup.bat lab 2.1` on their Windows VM.
2. Have students run `./setup.sh lab 2.1` on their Ubuntu VM.
3. Students perform investigation in Kibana at `http://<DOCKER_HOST>:5601`.

### End of Day Teardown / Reset

```bash
# Reset lab state for next day
./sd0601.sh lab reset 2.1

# Save volume snapshot
./sd0601.sh snapshot create day-2-end
```

---

## Service Swap (16GB Machines)

On 16GB RAM machines running the `STANDARD` profile, Splunk and MISP are disabled by default to prevent memory exhaustion.
To swap from Wazuh to Splunk for Lab 3.1:

```bash
./sd0601.sh lab setup 3.1 --swap-to splunk
```

This automatically stops Wazuh containers and starts Splunk Free.

---

## 🐉 Kali Linux Attacker VM Setup (Optional / Live Drills)

The environment supports an optional **Kali Linux Attacker VM** on IP `10.60.0.200` for live Red Team demonstrations:

1. **Boot Kali VM** on the `soc-lab` isolated network (`10.60.0.200`).
2. **Run setup script**:
   ```bash
   cd sd0601-lab-automation/kali
   ./setup-kali.sh
   ```
3. **Trigger Port Scan (Lab 3.1)**:
   ```bash
   ./nmap-scan.sh 10.60.0.100
   ```
4. **Trigger SSH Brute Force (Lab 2.1 / 6.1)**:
   ```bash
   ./ssh-bruteforce.sh 10.60.0.101
   ```

<!-- CHECKPOINT id="ckpt_msugaq19_fl55gv" time="2026-08-15T14:07:54.957Z" note="auto" fixes=0 questions=0 highlights=0 sections="" -->

<!-- CHECKPOINT id="ckpt_msugnkzr_vgurpv" time="2026-08-15T14:17:54.951Z" note="auto" fixes=0 questions=0 highlights=0 sections="" -->
