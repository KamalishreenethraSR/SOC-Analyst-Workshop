#!/usr/bin/env bash
# Module 6 / Lab 6.1 reset script

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"
source "$SCRIPT_DIR/automation/core/lib-state.sh"

log_info "Resetting Lab 6.1..."
set_lab_state "6.1" "reset" false
log_ok "Lab 6.1 reset complete."
