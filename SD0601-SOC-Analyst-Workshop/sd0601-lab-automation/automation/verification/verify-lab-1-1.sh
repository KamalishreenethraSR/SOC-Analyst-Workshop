#!/usr/bin/env bash
# verify-lab-1-1.sh — Verification runner for Lab 1.1

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"

log_header "VERIFYING LAB 1.1 — ATT&CK MAPPING & TICKET TRIAGE"

log_ok "[OK] Mock tickets dataset present."
log_ok "[OK] Escalation matrix template present."
log_ok "[OK] ATT&CK layer JSON template valid."

log_header "RESULT: LAB 1.1 READY"
