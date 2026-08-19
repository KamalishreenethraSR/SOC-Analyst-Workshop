# Master Setup Manual

## Prerequisites

- **Ubuntu Server / Ubuntu Desktop** (20.04 LTS or 22.04 LTS recommended)
- **Kali Linux** (for running attacker verification scripts)
- **Python 3.8+** with `pip` and `venv`
- Standard Unix utilities (`curl`, `awk`, `grep`)

---

## Installation & Environment Preparation

### 1. Ubuntu Target Setup

1. Open terminal on your Ubuntu Target system.
2. Navigate to the repository root directory:
   ```bash
   cd python-websec-soc-lab
   ```
3. Make all setup scripts executable:
   ```bash
   find . -type f -name "*.sh" -exec chmod +x {} +
   ```
4. Run the automated master setup script:
   ```bash
   ./setup_all.sh
   ```

This will automatically create a Python virtual environment (`venv`), install Python requirements (`Flask`, `requests`), initialize all SQLite databases, and configure initial log files across all 10 labs.

---

## Network Configuration

By default, labs bind to `0.0.0.0` or `127.0.0.1`.
To check system IP addresses:
```bash
./common/network_check.sh
```

If testing between separate Virtual Machines (e.g. Ubuntu Target VM and Kali Attacker VM), ensure both VMs are on the same host-only or bridged network.

---

## Verifying Installation

To verify that all 10 labs are properly initialized and ready:
```bash
./healthcheck_all.sh
```
