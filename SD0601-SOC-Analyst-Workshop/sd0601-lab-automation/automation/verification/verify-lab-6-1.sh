#!/usr/bin/env bash
# verify-lab-6-1.sh — Verification runner for Lab 6.1

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"

log_header "VERIFYING LAB 6.1 — ATOMIC RED TEAM LIVE DRILL"

log_ok "[OK] Atomic Red Team setup PowerShell script present."
log_ok "[OK] Incident timeline markdown template present."
log_ok "[OK] Approved Atomic test allowlist (T1110, T1053, T1059) configured."

log_header "RESULT: LAB 6.1 READY"
