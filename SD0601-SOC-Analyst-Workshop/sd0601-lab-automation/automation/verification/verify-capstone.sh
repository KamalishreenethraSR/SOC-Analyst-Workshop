#!/usr/bin/env bash
# verify-capstone.sh — Verification runner for Capstone SilentLedger

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"

log_header "VERIFYING CAPSTONE — OPERATION SILENTLEDGER"

if [ -d "$SCRIPT_DIR/evidence/capstone/variant-A" ]; then
    log_ok "[OK] Capstone Variant A evidence generated."
else
    log_warn "[FAIL] Capstone evidence not generated yet. Run: ./sd0601.sh capstone prepare"
fi

log_header "RESULT: CAPSTONE VERIFICATION COMPLETE"
