#!/usr/bin/env bash
# health-check.sh — Course-wide health check for SD0601 environment

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"

log_header "SD0601 ENVIRONMENT HEALTH CHECK"

PASS_COUNT=0
FAIL_COUNT=0

check_endpoint() {
    local name="$1"
    local url="$2"
    local expected_code="${3:-200}"

    local code
    code=$(curl -sk -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
    if [ "$code" -eq "$expected_code" ] || [ "$code" -eq 401 ] || [ "$code" -eq 302 ]; then
        log_ok "$name is REACHABLE (HTTP $code)"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        log_warn "$name is UNREACHABLE (HTTP $code) — URL: $url"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

check_endpoint "Elasticsearch API" "http://localhost:9200"
check_endpoint "Kibana Web UI" "http://localhost:5601"
check_endpoint "Splunk Web UI" "http://localhost:8000"
check_endpoint "Wazuh API" "https://localhost:55000" 200
check_endpoint "TheHive Web UI" "http://localhost:9000"
check_endpoint "Cortex API" "http://localhost:9001"
check_endpoint "MISP Web UI" "https://localhost:9443"

cat << EOF
======================================================================
 HEALTH CHECK SUMMARY
======================================================================
 Services Checked: $((PASS_COUNT + FAIL_COUNT))
 Services Passed:  $PASS_COUNT
 Services Failed:  $FAIL_COUNT

 RESULT: $([ "$FAIL_COUNT" -eq 0 ] && echo "READY" || ([ "$PASS_COUNT" -gt 0 ] && echo "WARNING" || echo "FAILED"))
======================================================================
EOF
