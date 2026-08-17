#!/usr/bin/env bash
# Module 5 / Lab 5.1 reset script

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"
source "$SCRIPT_DIR/automation/core/lib-state.sh"

log_info "Resetting Lab 5.1..."
set_lab_state "5.1" "reset" false
log_ok "Lab 5.1 reset complete."
