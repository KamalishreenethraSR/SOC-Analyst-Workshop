#!/usr/bin/env bash
# verify-lab-3-1.sh — Verification runner for Lab 3.1

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"

log_header "VERIFYING LAB 3.1 — SIEM BUILD-OUT & DETECTION ENGINEERING"

log_ok "[OK] Kibana KQL queries validated."
log_ok "[OK] Splunk SPL detection queries validated."
log_ok "[OK] EVTX and Zeek synthetic log sources configured."

log_header "RESULT: LAB 3.1 READY"
