#!/usr/bin/env bash
# Module 5 / Lab 5.1 setup script

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"
source "$SCRIPT_DIR/automation/core/lib-state.sh"

log_info "Setting up Lab 5.1 Wazuh EDR stack..."
docker compose -f "$SCRIPT_DIR/infrastructure/docker/wazuh/docker-compose.yml" up -d 2>/dev/null || log_warn "Wazuh startup skipped if insufficient RAM."
set_lab_state "5.1" "configured" false
log_ok "Lab 5.1 setup complete."
