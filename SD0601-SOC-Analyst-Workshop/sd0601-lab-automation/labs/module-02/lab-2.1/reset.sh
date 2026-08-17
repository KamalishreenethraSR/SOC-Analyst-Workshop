#!/usr/bin/env bash
# Module 2 / Lab 2.1 reset script

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"
source "$SCRIPT_DIR/automation/core/lib-state.sh"

log_info "Resetting Lab 2.1 ELK indices..."
curl -s -X DELETE "http://localhost:9200/winlogbeat-*,filebeat-*" -u "elastic:${ELASTIC_PASSWORD:-changeme}" &>/dev/null || true
set_lab_state "2.1" "reset" false
log_ok "Lab 2.1 reset complete."
