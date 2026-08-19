# Windows + WSL2 Setup Guide

## Overview

The **Python Web Application Security + WAF + SOC Lab** can be run natively on Windows using **Windows Subsystem for Linux 2 (WSL2)** with Ubuntu and Kali Linux distributions.

---

## Prerequisites & Installation

### 1. Enable WSL2

Open Windows PowerShell as Administrator and run:
```powershell
wsl --install
```
If WSL is already installed, verify installed distributions:
```powershell
wsl --list --verbose
```

### 2. Install WSL Distributions

Install Ubuntu and Kali Linux from Microsoft Store or PowerShell:
```powershell
wsl --install -d Ubuntu
wsl --install -d Kali-linux
```

---

## WSL Networking Notes

1. WSL2 operates on a virtual NAT network interface.
2. Applications running inside WSL Ubuntu listening on `0.0.0.0` can be accessed from Windows host via `localhost:PORT` or the WSL IP address.
3. To discover your WSL IP address:
   ```bash
   hostname -I
   ```
4. If running Kali Linux inside WSL2 on the same host, Kali can access Ubuntu services via `localhost` or the Ubuntu WSL IP address.

---

## Running the Lab in WSL

1. Open your WSL Ubuntu terminal.
2. Clone or navigate to the laboratory folder:
   ```bash
   cd /mnt/c/path/to/python-websec-soc-lab
   ```
3. Run the master setup:
   ```bash
   ./setup_all.sh
   ```
4. Run any lab suite:
   ```bash
   ./run_lab.sh 01
   ```
5. Open your web browser on Windows and navigate to:
   - Target App: `http://localhost:5001`
   - SOC Viewer: `http://localhost:8001`
