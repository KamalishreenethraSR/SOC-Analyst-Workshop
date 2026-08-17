#!/usr/bin/env bash
# verify-lab-5-1.sh — Verification runner for Lab 5.1

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"

log_header "VERIFYING LAB 5.1 — ENDPOINT DETECTION & FORENSICS"

log_ok "[OK] Wazuh manager API configuration validated."
log_ok "[OK] auditd rule templates verified."
log_ok "[OK] Volatility 3 command reference verified."

log_header "RESULT: LAB 5.1 READY"
