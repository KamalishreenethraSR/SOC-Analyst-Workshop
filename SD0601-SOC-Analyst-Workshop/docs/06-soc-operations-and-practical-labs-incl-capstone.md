# Module 6 — SOC Operations and Practical Labs (incl. Capstone)

**Schedule:** Day 5, Full Day (09:00–21:00)  
**Total:** 12h &nbsp;(Lecture: 2h · Hands-on Lab: 10h)

[⬅ Back to README](../README.md) | [Lab Guide ➡](../labs/lab-6.1-atomic-red-team-live-fire-detection-drill.md)

## 1. Hourly Breakdown

| Time Block  | Format       | Topic                                                                           |
| ----------- | ------------ | ------------------------------------------------------------------------------- |
| 09:00–09:45 | Lecture      | Escalation procedures, SLAs/SLOs, shift handover discipline                     |
| 09:45–10:30 | Lecture      | Incident documentation & executive reporting + SOC interview prep (STAR method) |
| 10:30–10:45 | Break        | —                                                                               |
| 10:45–13:00 | Hands-on Lab | Atomic Red Team attack simulation + live detection drill                        |
| 14:00–19:30 | Capstone Lab | Multi-stage breach investigation: 'Operation SilentLedger'                      |
| 19:30–21:00 | Capstone Lab | Report finalization, executive summary, and mock stakeholder presentation       |

## 2. Detailed Lesson Plan

### Key Concepts

- Real-time monitoring drills: sustained attention, alert queue management under load
- Incident escalation procedures: SLA-bound escalation from L1 → L2 → L3, communication templates
- Attack simulation with Atomic Red Team: mapping tests directly to ATT&CK Technique IDs for detection validation (purple teaming)
- Incident documentation & reporting: technical incident report vs executive summary; audience-appropriate language
- SOC Analyst interview preparation: STAR method for behavioral questions, common technical questions (log analysis, triage scenarios, tool proficiency)

### Industry Frameworks Referenced

- NIST SP 800-61 (applied end-to-end)
- MITRE ATT&CK (applied end-to-end via Atomic Red Team technique mapping)
- SANS Incident Report template structure

### Tools & Commands

- Atomic Red Team (Invoke-AtomicTest)
- Splunk/ELK (from Module 3)
- TheHive (from Module 4)
- Wazuh (from Module 5)

## 3. Practical Lab

See full lab blueprint: [`labs/lab-6.1-atomic-red-team-live-fire-detection-drill.md`](../labs/lab-6.1-atomic-red-team-live-fire-detection-drill.md)

## 4. Assessment & Checkpoints

### Review Questions

1. What is the purpose of an SLA in the context of alert escalation, and what happens when SLAs are consistently missed?
2. What is the difference between a technical incident report and an executive summary — who is each written for?
3. Using the STAR method, briefly structure an answer to: 'Tell me about a time you investigated a suspicious alert.'
4. Why is Atomic Red Team useful for a SOC to validate its own detections (purple teaming)?
5. What should be included in a proper SOC shift-handover note?

### Hands-on Lab Challenge

As the sole defender, detect, correctly triage, and escalate 2 back-to-back unannounced Atomic Red Team tests within a combined 15-minute SLA, with a fully documented TheHive case for each.

## 5. Final Capstone

This module culminates in the course capstone project. Full guide: [`capstone/operation-silentledger.md`](../capstone/operation-silentledger.md)
