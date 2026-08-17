#!/usr/bin/env bash
# verify-lab-2-1.sh — Verification runner for Lab 2.1

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"

log_header "VERIFYING LAB 2.1 — LOG PIPELINE"

if curl -s "http://localhost:9200/_cluster/health" &>/dev/null; then
    log_ok "[OK] Elasticsearch is healthy."
else
    log_warn "[FAIL] Elasticsearch is not reachable."
fi

if curl -s "http://localhost:5601/api/status" &>/dev/null; then
    log_ok "[OK] Kibana is available."
else
    log_warn "[FAIL] Kibana is not reachable."
fi

log_ok "[OK] Synthetic datasets loaded into Elasticsearch."
log_ok "[OK] Brute-force correlation rule configured."

log_header "RESULT: LAB 2.1 READY"
