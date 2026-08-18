# Smurf Attack DoS - Attacker Reference Guide

This folder documents standard Smurf attack mechanisms and theoretical parameters using security testing tools against a designated private network setup.

## 1. Overview of Smurf Attacks
A Smurf attack is a form of distributed denial-of-service (DDoS) attack. The attacker spoof-sends a large volume of ICMP Echo Request (ping) packets, setting the source IP address to that of the target system, and setting the destination address to the IP broadcast address of a local subnet. 

Every active host on that subnet receives the broadcast request and replies to the spoofed source IP (the target system). The target is flooded with replies from the entire network subnet, saturating its link capacity. This maps to **MITRE ATT&CK T1498 (Network Denial of Service)**.

## 2. Command Reference

### Simulating Smurf Broadcast Traffic using `hping3`
Spoofs the target's IP address and sends packets to the network's broadcast IP (e.g. `192.168.56.255`).

```bash
hping3 -1 -a 192.168.56.20 192.168.56.255
```
* **`-1`**: Specifies ICMP mode.
* **`-a 192.168.56.20`**: Spoofs the sender's source IP address as the target host.
* **`192.168.56.255`**: Subnet broadcast destination address.

## 3. Network Detection Signatures
* High rate of incoming ICMP Echo Requests sent to the subnet broadcast address.
* The target receives high volumes of unsolicited ICMP Type 0 (Echo Reply) packets from various hosts across its local subnet.
* Firewall logs recording incoming broadcast ICMP traffic under the `ICMP BROADCAST RECV:` rule header.
