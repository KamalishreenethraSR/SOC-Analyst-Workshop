#!/usr/bin/env bash
# Module 3 / Lab 3.1 setup script

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"
source "$SCRIPT_DIR/automation/core/lib-state.sh"

log_info "Setting up Lab 3.1 SIEM environment..."
docker compose -f "$SCRIPT_DIR/infrastructure/docker/elk/docker-compose.yml" up -d
docker compose -f "$SCRIPT_DIR/infrastructure/docker/splunk/docker-compose.yml" up -d 2>/dev/null || log_warn "Splunk startup skipped if insufficient RAM."
set_lab_state "3.1" "configured" false
log_ok "Lab 3.1 setup complete."
