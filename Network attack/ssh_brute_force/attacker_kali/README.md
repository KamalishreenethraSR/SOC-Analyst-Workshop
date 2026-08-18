# SSH Password Brute-Force Attack - Attacker Reference Guide

This folder documents standard SSH brute-forcing commands and theoretical parameters using security testing tools against a designated private target (e.g., `192.168.56.20`).

## 1. Overview of SSH Brute-Forcing
SSH brute-forcing involves systematically attempting login credentials (usernames and passwords) against a running SSH daemon. Attackers utilize pre-defined dictionaries of common credentials or system accounts to gain unauthorized shell access. This maps to **MITRE ATT&CK T1110 (Brute Force)**.

## 2. Command Reference

### Brute-Forcing using `hydra`
Hydra allows testing multiple credential combinations concurrently.

```bash
hydra -l admin -P /usr/share/wordlists/rockyou.txt -t 4 ssh://192.168.56.20
```
* **`-l admin`**: Specifies the target username to test (single login).
* **`-P /usr/share/wordlists/rockyou.txt`**: Specifies the path to the password list.
* **`-t 4`**: Restricts the search execution to 4 tasks/threads concurrently to prevent overwhelming the remote SSH system or causing service crashes.
* **`ssh://192.168.56.20`**: Declares target protocol and IP address.

### Testing username and password lists
If testing list of both usernames and passwords:
```bash
hydra -L /tmp/users.txt -P /tmp/passwords.txt -vV ssh://192.168.56.20
```
* **`-L`**: Specifies path to a text file containing usernames.
* **`-vV`**: Enables verbose mode, showing each login attempt.

## 3. Network Detection Signatures
* High frequency of authentication connection requests to TCP port 22 from a single source host.
* Log entries in `/var/log/auth.log` showing `Failed password` or `Connection closed by authenticating user` in rapid succession.
* Log alerts from local intrusion prevention platforms (like Fail2ban) indicating that an IP address has been banned.
