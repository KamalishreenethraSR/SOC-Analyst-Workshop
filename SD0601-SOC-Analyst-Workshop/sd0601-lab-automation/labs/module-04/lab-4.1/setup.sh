#!/usr/bin/env bash
# Module 4 / Lab 4.1 setup script

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"
source "$SCRIPT_DIR/automation/core/lib-state.sh"

log_info "Setting up Lab 4.1 TheHive stack..."
docker compose -f "$SCRIPT_DIR/infrastructure/docker/thehive/docker-compose.yml" up -d 2>/dev/null || log_warn "TheHive startup skipped if insufficient RAM."
set_lab_state "4.1" "configured" false
log_ok "Lab 4.1 setup complete."
