# Ping of Death Attack - Attacker Reference Guide

This folder documents standard Ping of Death commands and theoretical parameters using security testing tools against a designated private target (e.g., `192.168.56.20`).

## 1. Overview of Ping of Death Attacks
A Ping of Death (PoD) attack involves sending malformed or oversized ICMP packets (greater than the maximum IP packet size of 65,535 bytes) to a target system. Because the IP headers only allow 65,535 bytes, sending larger payloads forces the packet to be fragmented. When the target system reassembles the fragments, a buffer overflow can occur, causing kernel panic, system crashes, or freeze conditions. Modern operating systems are patched against this exploit, but the attempt still triggers defensive telemetry. This maps to **MITRE ATT&CK T1498 (Network Denial of Service)**.

## 2. Command Reference

### Sending Oversized ICMP packets via `hping3`
Uses the `-d` option to specify an extremely large data payload size.

```bash
hping3 -1 -d 65500 192.168.56.20
```
* **`-1`**: Specifies ICMP mode.
* **`-d 65500`**: Sets the data size to 65,500 bytes (exceeding typical IP fragment sizes and approaching the 65,535 limit when headers are added).

### Sending via `ping` (Alternative)
```bash
ping -s 65507 192.168.56.20
```
* **`-s 65507`**: Sets payload packet size. 65,507 is the maximum size for a standard ping tool payload on many systems.

## 3. Network Detection Signatures
* High count of IP fragments arriving at the interface that cannot be immediately reassembled.
* Network IDS alerts identifying ICMP Echo Requests with dynamic sizes exceeding `60,000` bytes.
* Kernel warnings regarding IP fragmentation parsing issues.
