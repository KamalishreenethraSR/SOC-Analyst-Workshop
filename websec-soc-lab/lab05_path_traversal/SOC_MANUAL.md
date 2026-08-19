# SOC Investigation Manual — Lab 05 — Path Traversal

This manual guides Security Operations Center (SOC) analysts step-by-step through investigating security events generated in **Lab 05 — Path Traversal**.

---

## 🔍 SOC Investigation Workflow (10-Step Checklist)

1. **Open SOC Dashboard**: Open web browser to `http://localhost:8005`.
2. **Identify High Severity Alerts**: Locate events with **HIGH** or **MEDIUM** severity tags.
3. **Verify Source IP**: Note the client IP address initiating the requests.
4. **Inspect HTTP Method & URL**: Examine whether the request was a `GET` or `POST` request and analyze path parameters.
5. **Analyze Attack Signature**: Check the `Attack Type` column (e.g. `PATH_TRAVERSAL`).
6. **Evaluate WAF Action**: Check if the WAF status is `BLOCKED` (403) or `ALLOWED` (200).
7. **Examine Payload Details**: View the exact payload string captured in `security.db`.
8. **Correlate Application Logs**: Check `/ubuntu_target/app.log` and `waf.log` on the target server.
9. **Determine Impact**: Verify whether backend data was modified or accessed.
10. **Formulate Remediation**: Recommend defensive controls (Use safe path resolution libraries (os.path.basename) and verify that the target canonical path begins with the allowed root directory path.).

---

## 📊 Event Severity Matrix

| Event Type | Severity | Description | Action Required |
|---|---|---|---|
| `BASELINE_TRAFFIC` | LOW | Standard user HTTP GET/POST request | No action required |
| `PATH_TRAVERSAL` | HIGH/MEDIUM | Security violation pattern detected by WAF | Monitor IP, verify block status, alert administrator |
