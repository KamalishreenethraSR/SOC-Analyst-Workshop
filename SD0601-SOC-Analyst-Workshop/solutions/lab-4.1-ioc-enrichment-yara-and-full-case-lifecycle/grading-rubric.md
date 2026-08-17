# Lab 4.1 — Grading Rubric: IOC Enrichment, YARA, and Full Case Lifecycle

**Total Points: 100**

---

## Part 1 — IOC Enrichment (25 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| SHA-256 hash computed correctly | 3 | Correct hash shown in terminal output |
| Hash looked up in VirusTotal with result documented | 5 | Screenshot or copy of VT result showing detection count |
| Sender IP and embedded URL extracted from .eml | 5 | Correct IP and URL extracted (use `grep` or email client headers) |
| AbuseIPDB lookup performed with result documented | 5 | AbuseIPDB score for sender IP |
| VirusTotal domain/URL lookup result documented | 4 | VT result for phishing domain |
| All IOC findings compiled in one place | 3 | IOC table with value, type, and verdict for each |

---

## Part 2 — MISP Event (20 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| Event created in MISP with correct title and date | 3 | MISP event visible with appropriate info field |
| Hash attribute: correct type (`sha256`) and category | 4 | Attribute list shows sha256 under Payload delivery |
| IP attribute: correct type (`ip-src`) with IDS flag | 4 | ip-src attribute with to_ids=true |
| Domain attribute: correct type and category | 4 | domain attribute under Network activity |
| TLP tag applied correctly (TLP:AMBER or stricter) | 3 | TLP tag visible on event |
| At least one MITRE ATT&CK galaxy tag added | 2 | ATT&CK technique galaxy tag on event or attribute |

---

## Part 3 — YARA Rule (25 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| Rule file is syntactically valid YARA | 5 | `yara` does not throw parse error |
| Rule contains at least one `strings:` section | 5 | Strings section with at least one pattern |
| Rule `condition:` correctly references defined strings | 5 | Condition uses variable names defined in strings block |
| Rule matches the provided sample | 7 | `yara rule.yar sample.exe` outputs the rule name |
| Rule includes metadata (author, date, description, MITRE tag) | 3 | `meta:` section with at least 3 metadata fields |

---

## Part 4 — TheHive Case (30 points)

| Criterion | Points | Evidence Required |
|-----------|--------|-----------------|
| Case created with correct title, severity (High), and TLP | 3 | Case visible in TheHive UI |
| All 3 IOCs added as Observables with correct types | 5 | hash, ip, domain observables shown |
| Cortex analyzers run on observables | 5 | Analyzer results visible (VT for hash; AbuseIPDB for IP) |
| Detection & Analysis phase documented | 5 | Case task or comment covering: timeline, source, scope, indicators |
| Containment actions proposed and documented | 4 | At least 3 containment steps documented |
| Eradication steps documented | 4 | At least 2 eradication steps |
| Recovery steps documented | 2 | At least 1 recovery step |
| Case closed with verdict + Lessons Learned | 2 | TP/FP verdict and at least 1 lesson |

---

## Lab Challenge Bonus (10 bonus points)

| Criterion | Points |
|-----------|--------|
| Challenge sample hash computed and VT'd | 2 |
| MISP event created for new sample | 2 |
| YARA rule written and matches challenge sample | 3 |
| TheHive case progressed through all 4 NIST phases | 2 |
| Completed within 45-minute timer | 1 |

---

## Scoring Bands

| Score | Band |
|-------|------|
| 90–100 | Distinction |
| 75–89 | Merit |
| 60–74 | Pass |
| < 60 | Requires Re-sit |

---

[⬅ Solution](./solution.md) | [⬅ Back to Solutions Index](../README.md)
