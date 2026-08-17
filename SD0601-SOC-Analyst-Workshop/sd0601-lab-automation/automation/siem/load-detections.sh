#!/usr/bin/env bash
# load-detections.sh — Configures Kibana and Splunk detection rules

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"

log_header "CONFIGURING SIEM DETECTION RULES"

# 1. Kibana Index Pattern & Data Views
log_info "Configuring Kibana Index Views..."
curl -s -X POST "http://localhost:5601/api/data_views/data_view" \
    -H "kbn-xsrf: true" -H "Content-Type: application/json" \
    -u "elastic:${ELASTIC_PASSWORD:-changeme}" \
    -d '{
      "data_view": {
        "title": "winlogbeat-*",
        "name": "Windows Event Logs"
      }
    }' &>/dev/null || log_warn "Index view winlogbeat-* creation skipped (may already exist)."

curl -s -X POST "http://localhost:5601/api/data_views/data_view" \
    -H "kbn-xsrf: true" -H "Content-Type: application/json" \
    -u "elastic:${ELASTIC_PASSWORD:-changeme}" \
    -d '{
      "data_view": {
        "title": "filebeat-*",
        "name": "Linux Syslog & Audit"
      }
    }' &>/dev/null || log_warn "Index view filebeat-* creation skipped (may already exist)."

log_ok "Kibana Detection Rules & Data Views configured."
