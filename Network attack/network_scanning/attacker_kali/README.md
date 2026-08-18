# Network Scanning (Reconnaissance) - Attacker Reference Guide

This folder documents standard network scanning commands and theoretical usage parameters using the `nmap` security tool against an authorized target environment (e.g., `192.168.56.20`).

## 1. Overview of Network Scanning
Network scanning is used to identify active hosts, open ports, and running services on a target network segment. This corresponds to **MITRE ATT&CK T1595 (Active Scanning)**.

## 2. Command Reference

### A. Ping Sweep / Host Discovery
Identifies live hosts in a target subnet without performing port scans.
```bash
nmap -sn 192.168.56.0/24
```
* **`-sn`**: Disables port scanning (previously `-sP`).

### B. TCP SYN Port Scan (Half-Open Scan)
Performs a fast, stealthy port scan by sending SYN packets and analyzing the response without establishing a full TCP connection.
```bash
nmap -sS -p 1-1024 192.168.56.20
```
* **`-sS`**: Specifies TCP SYN scan.
* **`-p 1-1024`**: Restricts the scan to ports 1 through 1024.

### C. Service and Version Detection
Probes open ports to determine service names, server software versions, and operating system properties.
```bash
nmap -sV -O 192.168.56.20
```
* **`-sV`**: Probe open ports to determine service/version info.
* **`-O`**: Enable OS detection.

### D. UDP Port Scan
Scans for active UDP services on the target.
```bash
nmap -sU --top-ports 50 192.168.56.20
```
* **`-sU`**: Specifies UDP scan mode.
* **`--top-ports 50`**: Restricts the scan to the 50 most common UDP ports.

## 3. Network Detection Signatures
* High-volume TCP connection attempts from a single source host to consecutive/different ports within a short window.
* TCP packets with only the SYN flag set that are not followed by an ACK or a completion of the three-way handshake.
* ICMP Echo Requests sent systematically across a subnet range.
