# Student Guide

## Welcome to Web Application Security & SOC Lab!

This practical laboratory suite will guide you through understanding web application vulnerabilities, Web Application Firewalls (WAF), and Security Operations Center (SOC) log analysis.

---

## 🛠️ Getting Started

### Step 1: Open Terminal
Navigate to the lab directory:
```bash
cd python-websec-soc-lab
```

### Step 2: Choose a Lab
To start Lab 03 (SQL Injection):
```bash
cd lab03_sql_injection
```

### Step 3: Start the Target Environment
Inside the lab folder, launch the target application, WAF, and log viewer:
```bash
./ubuntu_target/start.sh
./logviewer/start.sh
```

### Step 4: Run the Attack Simulation
Run the Kali attacker script to simulate controlled security testing:
```bash
./attacker_kali/attack.sh
```

### Step 5: Investigate in SOC Log Viewer
Open your web browser and navigate to the SOC Log Viewer dashboard:
- Lab 01 Dashboard: `http://localhost:8001`
- Lab 03 Dashboard: `http://localhost:8003`

Observe the security alerts, severity ratings, WAF action (ALLOWED / BLOCKED), and request payload details!

---

## 🧹 Cleaning Up & Resetting

To reset your lab environment to a clean initial state:
```bash
./ubuntu_target/reset.sh
```
To stop running processes:
```bash
./ubuntu_target/stop.sh
./logviewer/stop.sh
```
