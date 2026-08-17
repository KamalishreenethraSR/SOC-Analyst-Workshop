# SD0601 — Student Lab Guide

Welcome to the SD0601 SOC Analyst Workshop!

## Accessing Your Lab Interfaces

| Service | URL | Credentials |
|---------|-----|-------------|
| **Kibana SIEM** | `http://<DOCKER_HOST>:5601` | `elastic` / `changeme` |
| **Splunk Web** | `http://<DOCKER_HOST>:8000` | `admin` / `changeme` |
| **Wazuh Dashboard** | `https://<DOCKER_HOST>:8443` | `admin` / `SecretPassword` |
| **TheHive 5** | `http://<DOCKER_HOST>:9000` | `admin@thehive.local` / `secret` |

---

## How to Prepare Your Virtual Machines

### On Your Windows VM
Open Administrator Command Prompt:
```cmd
setup.bat install
setup.bat lab 2.1
setup.bat verify
```

### On Your Ubuntu VM
Open Terminal:
```bash
./setup.sh install
./setup.sh lab 2.1
./setup.sh verify
```

---

## Workspace Directory Structure
Your submissions and notes go into your personal workspace directory:
`students/STUDENT001/module-01/`, `module-02/`, etc.
