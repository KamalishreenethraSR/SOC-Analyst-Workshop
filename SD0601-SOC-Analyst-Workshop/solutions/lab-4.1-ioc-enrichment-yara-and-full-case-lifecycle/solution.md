# Lab 4.1 — Solution: IOC Enrichment, YARA, and Full Case Lifecycle

**Module:** [Module 4 — Threat Detection and Incident Response](../../docs/04-threat-detection-and-incident-response.md)

---

## Step 1 — Compute SHA-256 Hash of the Executable

**Linux/macOS:**
```bash
sha256sum ~/lab-evidence/sample.exe
# Expected output:
# 275a021bbfb6489e54d471899f7db9d1663fc695ec2fe2a2c4538aabf651fd0f  sample.exe
```

**Windows PowerShell:**
```powershell
Get-FileHash .\sample.exe -Algorithm SHA256 | Select-Object Hash, Path
# Output:
# Hash                                                              Path
# 275A021BBFB6489E54D471899F7DB9D1663FC695EC2FE2A2C4538AABF651FD0F  .\sample.exe
```

**VirusTotal Lookup:**
1. Navigate to https://www.virustotal.com/gui/home/upload
2. Click **Search** → paste hash
3. Expected result (EICAR test): `~60/72 engines` detect it as `EICAR-Test-File`

**VirusTotal API (command line):**
```bash
VT_API_KEY="<your_api_key>"
HASH="275a021bbfb6489e54d471899f7db9d1663fc695ec2fe2a2c4538aabf651fd0f"

curl -s "https://www.virustotal.com/api/v3/files/${HASH}" \
  -H "x-apikey: ${VT_API_KEY}" | \
  python3 -m json.tool | grep -E '"malicious"|"harmless"|"type_description"'
```

**Expected Output:**
```json
"malicious": 60,
"harmless": 4,
"type_description": "DOS executable"
```

---

## Step 2 — Extract and Enrich IOCs from Phishing Email

**Parse the .eml file:**
```bash
# View raw email headers
cat ~/lab-evidence/phishing.eml | head -50

# Extract sender IP from Received headers
grep -i "^Received:" ~/lab-evidence/phishing.eml | head -5
# Example: Received: from mail.ledger-secure-update.com (185.220.101.55)

# Extract embedded URLs using grep
grep -oP 'https?://[^\s"<>]+' ~/lab-evidence/phishing.eml | sort -u
# Expected:
# http://185.220.101.55/payload.zip
# https://ledger-secure-update.com/invoice/Invoice_August2024.docm
```

**AbuseIPDB Lookup:**
```bash
ABUSEIPDB_KEY="<your_api_key>"
SENDER_IP="185.220.101.55"

curl -s "https://api.abuseipdb.com/api/v2/check?ipAddress=${SENDER_IP}&maxAgeInDays=90" \
  -H "Key: ${ABUSEIPDB_KEY}" -H "Accept: application/json" | \
  python3 -m json.tool | grep -E '"abuseConfidenceScore"|"totalReports"|"countryCode"'
```

**Expected Output:**
```json
"abuseConfidenceScore": 100,
"totalReports": 847,
"countryCode": "DE"
```

**VirusTotal Domain Check:**
```bash
DOMAIN="ledger-secure-update.com"
curl -s "https://www.virustotal.com/api/v3/domains/${DOMAIN}" \
  -H "x-apikey: ${VT_API_KEY}" | \
  python3 -m json.tool | grep -E '"malicious"|"reputation"'
```

---

## Step 3 — Create MISP Event

**MISP UI Steps:**
1. Log in to MISP → **Add Event**
2. Distribution: `Your organisation only`
3. Threat Level: `High`
4. Analysis: `Ongoing`
5. Event Info: `Lab 4.1 — Phishing Campaign — Invoice Lure — August 2024`

**Add Attributes:**
| Value | Category | Type | IDS Flag | TLP |
|-------|----------|------|----------|-----|
| `275a021b...` | Payload delivery | `sha256` | ✓ | TLP:AMBER |
| `185.220.101.55` | Network activity | `ip-src` | ✓ | TLP:AMBER |
| `ledger-secure-update.com` | Network activity | `domain` | ✓ | TLP:AMBER |
| `Invoice_August2024.docm` | Payload delivery | `filename` | ✓ | TLP:AMBER |

**Tags to add:**
- `tlp:amber`
- `misp-galaxy:mitre-attack-pattern="Spearphishing Attachment - T1566.001"`
- `misp-galaxy:mitre-attack-pattern="User Execution - T1204"`

**Via MISP API (alternative):**
```bash
MISP_KEY="<your_misp_api_key>"
MISP_URL="https://localhost"

# Create event
curl -sk -H "Authorization: ${MISP_KEY}" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"Event":{"distribution":0,"threat_level_id":1,"analysis":1,"info":"Lab 4.1 Phishing Campaign"}}' \
  "${MISP_URL}/events/add"
```

> See full MISP event template in [`assets/misp-event-template.json`](./assets/misp-event-template.json)

---

## Step 4 — Write and Run YARA Rule

**Inspect sample for distinctive strings:**
```bash
# View printable strings in the binary
strings ~/lab-evidence/sample.exe | grep -i "EICAR\|malicious\|payload"
# Expected (EICAR test file):
# X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*
```

**Write the YARA Rule:**
```bash
cat > ~/lab-evidence/suspicious_rule.yar << 'YARARULE'
/*
    Rule: Suspicious_Lab_Sample
    Author: SOC Lab Student
    Date: 2024-08-14
    Description: Detects EICAR test file or similar test binary used in Lab 4.1
    Reference: T1204.002 - User Execution: Malicious File
*/

rule Suspicious_Lab_Sample
{
    meta:
        description = "Detects the Lab 4.1 sample executable by string signature"
        author = "SOC Lab"
        date = "2024-08-14"
        mitre_attack = "T1204.002"
        tlp = "TLP:AMBER"

    strings:
        $eicar_string = "EICAR-STANDARD-ANTIVIRUS-TEST-FILE" ascii
        $ps_download = "Invoke-WebRequest" ascii nocase
        $encoded_cmd = "-EncodedCommand" ascii nocase

    condition:
        $eicar_string or ($ps_download and $encoded_cmd)
}
YARARULE

# Run YARA against the sample
yara ~/lab-evidence/suspicious_rule.yar ~/lab-evidence/sample.exe
```

**Expected YARA Output:**
```
Suspicious_Lab_Sample /home/student/lab-evidence/sample.exe
```

> This confirms the rule matched. A match = the file triggered at least one condition.  
> **No output** = the rule did NOT match (review strings and condition).

> Full rule file also available in [`assets/suspicious_rule.yar`](./assets/suspicious_rule.yar)

---

## Step 5 — TheHive Case Creation and Cortex Analysis

**TheHive Steps:**

1. **Create Case:**
   - Title: `Lab 4.1 — Phishing Campaign: Invoice Lure`
   - Severity: `High`
   - TLP: `Amber`
   - PAP: `Amber`
   - Tags: `phishing`, `T1566.001`, `lab-4.1`

2. **Add Observables:**
   | Value | Type | TLP | IDS |
   |-------|------|-----|-----|
   | `275a021b...` | `hash` | Amber | ✓ |
   | `185.220.101.55` | `ip` | Amber | ✓ |
   | `ledger-secure-update.com` | `domain` | Amber | ✓ |

3. **Run Cortex Analyzers (for each observable):**
   - Right-click observable → **Run analyzers**
   - Run: `VirusTotal_GetReport_3_0` + `AbuseIPDB` (on IP)

**Expected Cortex Results:**
```
VirusTotal (hash):    malicious: 60, harmless: 4 → SUSPICIOUS
VirusTotal (domain):  malicious: 8 → SUSPICIOUS
AbuseIPDB (IP):       abuseConfidenceScore: 100 → MALICIOUS
```

---

## Step 6 — NIST SP 800-61 Case Documentation

### Phase 1: Detection & Analysis

```
Detection Source: Email gateway alert (user-reported phishing) + Cortex VT/AbuseIPDB analysis
Timeline:
  10:14 UTC — User jdoe@company.com reports suspicious .docm email
  10:22 UTC — SOC Tier 1 opens TheHive case
  10:35 UTC — Cortex analysis completes: all IOCs confirmed malicious
  10:40 UTC — Severity escalated to High; Tier 2 notified

Indicators:
  - Hash: 275a021b... (60/72 VT detections)
  - IP: 185.220.101.55 (AbuseIPDB score: 100)
  - Domain: ledger-secure-update.com (phishing infrastructure)

Scope: 7 recipients in Finance team identified from email metadata
```

### Phase 2: Containment

```
Immediate actions:
  1. Block sender domain at email gateway (ledger-secure-update.com)
  2. Block IP 185.220.101.55 at perimeter firewall (egress ACL)
  3. Quarantine Invoice_August2024.docm from all mailboxes via email admin console
  4. Check EDR/Sysmon for any exec of the docm (EventCode 1, ParentImage=WINWORD.EXE)
  5. If any host shows WinWord→PowerShell chain: isolate host from network immediately

Long-term containment:
  - Reset credentials for any user who opened the attachment
  - Deploy email quarantine policy for .docm attachments pending review
```

### Phase 3: Eradication

```
1. Remove quarantined .docm files from all mailboxes
2. Scan all endpoints with updated signatures (hash added to AV policy)
3. Check Sysmon Event ID 1 for any persistence: scheduled tasks (Event 4698),
   registry run keys created by Office processes
4. Remove any identified persistence mechanisms
5. Patch: ensure Office macro execution requires explicit user opt-in
   (GPO: Disable macros unless signed by trusted publisher)
```

### Phase 4: Recovery

```
1. Verify no persistence remains (re-run Autoruns/Volatility on affected hosts)
2. Restore any affected hosts from known-good backup if compromise confirmed
3. Monitor affected Finance team hosts for 30 days post-incident
4. Re-enable email attachment policies after implementing macro restrictions
5. Confirm with IT: email gateway now blocking .docm from external sources
```

### Case Closure

```
Verdict: TRUE POSITIVE — Active phishing campaign targeting Finance team
         No confirmed execution detected (no WinWord→PowerShell events found)
         Classified as Attempted Intrusion — contained before payload executed

Lessons Learned:
  - Office macro restrictions were not enforced via GPO → remediated
  - No email gateway rule existed for .docm from external domains → remediated
  - Detection relied on user reporting (no automated email scanning alert)
    → Request DMARC/DKIM enforcement review + email security product assessment
```

---

## Lab Challenge Solution — Unseen Sample Workflow

```bash
# 1. Hash
sha256sum ~/lab-evidence/challenge_sample.exe

# 2. VirusTotal lookup
curl -s "https://www.virustotal.com/api/v3/files/<HASH>" -H "x-apikey: $VT_API_KEY"

# 3. MISP event
# Add hash, IP, domain as attributes with TLP:AMBER + ATT&CK tags

# 4. YARA rule template
rule Challenge_Sample {
  strings:
    $str1 = "<distinctive_string_from_strings_output>" ascii
  condition:
    $str1
}
yara challenge_rule.yar challenge_sample.exe

# 5. TheHive case → observables → Cortex analyzers → NIST phases
# Follow same workflow as above, substituting new IOCs
```

---

[⬅ Setup](./setup.md) | [Grading Rubric ➡](./grading-rubric.md)
