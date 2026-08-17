# Lab 1.1 — ATT&CK Mapping & Ticket Triage

**Module:** [Module 1 — SOC Fundamentals](../docs/01-soc-fundamentals.md)

## Scenario

Students receive a 6-line attack narrative (phishing email → macro execution → PowerShell download → scheduled task persistence → credential dumping → lateral RDP) and a queue of 8 mock SOC tickets of mixed severity.

## Step-by-Step

1. Open MITRE ATT&CK Navigator and create a new layer named 'Lab1-<StudentID>'.
2. For each stage of the attack narrative, identify the correct Tactic (TAxxxx) and Technique (Txxxx) and highlight it on the Navigator layer.
3. Export the layer as JSON and save as evidence of mapping.
4. Open the mock ticket queue (osTicket/TheHive demo instance) containing 8 tickets.
5. Classify each ticket as True Positive, False Positive, or Benign-Positive, and assign a priority (P1–P4) using the provided Escalation Matrix.
6. Document justification for each classification in the ticket notes field.

## Expected Outcomes

- A completed ATT&CK Navigator layer JSON covering at least 5 distinct techniques
- A triaged ticket queue with priority tags and written justification for each classification

## Hands-on Lab Challenge

Given a new 4-stage attack narrative, produce a complete ATT&CK Navigator layer and correctly triage 5 additional mock tickets within 30 minutes.



