# Lab 4.1 — IOC Enrichment, YARA, and Full Case Lifecycle

**Module:** [Module 4 — Threat Detection and Incident Response](../docs/04-threat-detection-and-incident-response.md)

## Scenario

Students receive: a suspicious executable (safe, instructor-provided sample or EICAR-style test file), a phishing email (.eml) with an embedded malicious link, and one file hash with no other context.

## Step-by-Step

1. Compute the SHA-256 hash of the provided binary (sha256sum sample.exe or Get-FileHash sample.exe -Algorithm SHA256) and look it up in VirusTotal.
2. Extract the sender IP and embedded URL/domain from the .eml file; check the IP in AbuseIPDB and the domain in VirusTotal.
3. Create a new MISP event: add the hash, IP, and domain as attributes with correct MISP categories/types, and tag the event with an appropriate TLP marking.
4. Write a basic YARA rule that matches a distinctive string or byte sequence found in the sample (e.g., rule Suspicious_Sample { strings: $s1 = "malicious_string" condition: $s1 }) and run it: yara suspicious_rule.yar sample.exe.
5. In TheHive, create a new case from the alert, attach all three IOCs as observables, and run available Cortex analyzers (VirusTotal, AbuseIPDB analyzers) against them.
6. Progress the case through each NIST SP 800-61 phase: document Detection & Analysis findings, propose Containment actions (isolate host, block IOC at firewall/proxy), Eradication steps (remove malware, reset credentials), and Recovery steps (restore from backup, monitor for recurrence).
7. Close the case with a documented verdict (True Positive/False Positive) and a Lessons-Learned note.

## Expected Outcomes

- A MISP event with 3 correctly typed and tagged IOCs
- A working YARA rule that successfully matches the sample
- A fully documented TheHive case covering all 4 NIST IR lifecycle phases

## Hands-on Lab Challenge

Given a second, unseen malware sample and phishing artifact, complete the full enrichment-to-case-closure workflow (hash lookup → MISP event → YARA rule → TheHive case through all 4 IR phases) within 45 minutes.


