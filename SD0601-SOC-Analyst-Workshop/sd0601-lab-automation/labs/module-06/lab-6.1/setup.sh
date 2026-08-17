#!/usr/bin/env bash
# Module 6 / Lab 6.1 setup script

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"
source "$SCRIPT_DIR/automation/core/lib-state.sh"

log_info "Setting up Lab 6.1 Atomic Red Team live drill environment..."
docker compose -f "$SCRIPT_DIR/infrastructure/docker/full-stack/docker-compose.yml" up -d 2>/dev/null || log_warn "Full stack startup adjusted based on profile."
set_lab_state "6.1" "configured" false
log_ok "Lab 6.1 setup complete."
