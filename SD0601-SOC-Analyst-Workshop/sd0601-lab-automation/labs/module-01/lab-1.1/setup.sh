#!/usr/bin/env bash
# Module 1 / Lab 1.1 setup script

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"
source "$SCRIPT_DIR/automation/core/lib-state.sh"

log_info "Setting up Lab 1.1 workspace..."
set_lab_state "1.1" "configured" false
log_ok "Lab 1.1 workspace ready."
