#!/usr/bin/env bash
# Module 2 / Lab 2.1 setup script

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"
source "$SCRIPT_DIR/automation/core/lib-state.sh"

log_info "Setting up Lab 2.1 ELK pipeline..."
docker compose -f "$SCRIPT_DIR/infrastructure/docker/elk/docker-compose.yml" up -d
set_lab_state "2.1" "configured" false
log_ok "Lab 2.1 setup complete."
