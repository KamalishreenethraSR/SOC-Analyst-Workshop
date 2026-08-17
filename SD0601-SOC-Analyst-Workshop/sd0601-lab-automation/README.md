# SD0601 — SOC Analyst Workshop Automation Platform

A complete **Infrastructure-as-Code**, **Lab-as-Code**, **Detection-as-Code**, and **Evidence-as-Code** orchestration system for the **SD0601 SOC Analyst: Security Monitoring and Incident Response** course.

---

## 🚀 Quick Start (Instructor)

```bash
# 1. Clone repository & initialize
cd /home/dev/Templates/sd0601-lab-automation

# 2. Run automated preflight, profile selection, & stack deployment
./sd0601.sh install

# 3. Verify course-wide health status
./sd0601.sh health

# 4. Setup specific lab environment
./sd0601.sh lab setup 2.1

# 5. Verify lab readiness
./sd0601.sh lab verify 2.1
```

---

## 💻 Student Commands (Windows VM)

Open Administrator Command Prompt or PowerShell on the Windows VM:

```cmd
setup.bat install           :: Install Sysmon, Winlogbeat, Wazuh agent
setup.bat lab 2.1           :: Configure Windows environment for Lab 2.1
setup.bat verify            :: Run Windows-side health check
setup.bat reset             :: Reset Windows lab state
```

---

## 🐧 Student Commands (Ubuntu VM)

Open Terminal on the Ubuntu VM:

```bash
./setup.sh install          # Install Filebeat, auditd, Wazuh agent
./setup.sh lab 2.1          # Configure Linux environment for Lab 2.1
./setup.sh verify           # Run Linux-side health check
./setup.sh reset            # Reset Linux lab state
```

---

## 🧠 RAM Profile System

The system automatically detects free available RAM and selects a resource profile:

| Profile | Available RAM | Services Active |
|---------|---------------|-----------------|
| **MINIMAL** | ≥ 5 GB | ELK (Elasticsearch + Kibana) |
| **STANDARD** | ≥ 10 GB | ELK + Wazuh + TheHive + Cortex |
| **FULL** | ≥ 20 GB | All services (ELK, Splunk, Wazuh, TheHive, Cortex, MISP) |
| **INSTRUCTOR** | ≥ 48 GB | All services with maximum JVM heaps |

---

## 📄 Documentation Links

- [Instructor Guide](INSTRUCTOR_GUIDE.md)
- [Student Guide](STUDENT_GUIDE.md)
- [Troubleshooting & FAQs](TROUBLESHOOTING.md)
- [Lab Matrix & Mappings](LAB_MATRIX.md)
- [Security Model & Safety Boundaries](SECURITY_MODEL.md)
