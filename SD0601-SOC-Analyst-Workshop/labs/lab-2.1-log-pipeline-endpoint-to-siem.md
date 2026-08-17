# Lab 2.1 — Log Pipeline: Endpoint to SIEM

**Module:** [Module 2 — Security Monitoring and Log Management](../docs/02-security-monitoring-and-log-management.md)

## Scenario

A fresh Windows 10/11 VM and an Ubuntu VM are provided. Neither ships logs anywhere yet. Students must build a working collection pipeline into a local Elasticsearch/Kibana stack (docker-compose provided).

## Step-by-Step

1. Install Sysmon on the Windows VM using the SwiftOnSecurity sysmonconfig.xml.
2. Generate test telemetry: run notepad.exe, then powershell.exe -Command "Invoke-WebRequest http://example.com" to create process-creation and network-connection events.
3. Install and configure Winlogbeat on Windows to ship Security + Sysmon/Operational channels to Elasticsearch (output.elasticsearch: hosts).
4. On the Ubuntu VM, configure Filebeat to tail /var/log/auth.log and /var/log/syslog, output to the same Elasticsearch instance.
5. Generate test events on Linux: attempt 5 failed SSH logins (ssh baduser@localhost) to populate auth.log.
6. In Kibana, create an index pattern and verify both Windows Sysmon events and Linux auth events are visible and searchable.
7. Using grep/awk on the raw auth.log (grep 'Failed password' /var/log/auth.log | awk '{print $11}' | sort | uniq -c), extract the top offending source IPs manually.
8. Write a plain-language correlation rule: 'IF 5+ failed SSH logins from the same source IP within 5 minutes THEN raise Alert: Possible Brute Force' and document how you would implement it in Kibana/Elasticsearch (using an aggregation query).

## Expected Outcomes

- Working Winlogbeat + Filebeat pipeline visible in Kibana Discover view
- A documented manual correlation rule with the supporting grep/awk evidence

## Hands-on Lab Challenge

Within 40 minutes, stand up Filebeat shipping a second Linux log source (e.g., /var/log/apache2/access.log or a sample sudo log) into the same Elasticsearch cluster and confirm field extraction in Kibana Discover.



