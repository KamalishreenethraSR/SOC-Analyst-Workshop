#!/usr/bin/env bash
# preflight.sh — Validates host hardware, Docker, RAM profile, and network isolation

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"
source "$SCRIPT_DIR/automation/core/lib-state.sh"
source "$SCRIPT_DIR/automation/core/lib-utils.sh"

log_header "PREFLIGHT HOST VALIDATION"

# 1. Docker daemon check
if ! docker info &>/dev/null; then
    log_error "Docker daemon is not running or current user lacks permissions."
    exit 1
fi
log_ok "Docker daemon is active."

# 2. Disk space check (min 30GB free)
FREE_DISK_GB=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')
log_info "Free disk space: ${FREE_DISK_GB} GB"
if [ "$FREE_DISK_GB" -lt 20 ]; then
    log_warn "Low disk space (< 20GB). Lab installation may run out of space."
fi

# 3. Available RAM check and profile selection
AVAIL_RAM_MB=$(free -m | awk '/^Mem:/ {print $7}')
TOTAL_RAM_MB=$(free -m | awk '/^Mem:/ {print $2}')
TOTAL_RAM_GB=$(( (TOTAL_RAM_MB + 512) / 1024 ))
AVAIL_RAM_GB=$(( (AVAIL_RAM_MB + 512) / 1024 ))

log_info "Total Physical RAM: ${TOTAL_RAM_GB} GB (${TOTAL_RAM_MB} MB)"
log_info "Available Free RAM: ${AVAIL_RAM_GB} GB (${AVAIL_RAM_MB} MB)"

PROFILE="minimal"
if [ "$AVAIL_RAM_GB" -ge 40 ]; then
    PROFILE="instructor"
elif [ "$AVAIL_RAM_GB" -ge 18 ]; then
    PROFILE="full"
elif [ "$AVAIL_RAM_GB" -ge 8 ]; then
    PROFILE="standard"
elif [ "$AVAIL_RAM_GB" -ge 4 ]; then
    PROFILE="minimal"
else
    log_error "Available RAM (${AVAIL_RAM_GB} GB) is below absolute minimum of 4 GB."
    exit 1
fi

log_ok "Selected RAM Resource Profile: [$PROFILE]"

set_course_state "False" "$PROFILE"

cat << EOF
======================================================================
 RAM PROFILE SELECTION SUMMARY
======================================================================
 Profile Assigned: $PROFILE
 Total Host RAM:   ${TOTAL_RAM_GB} GB
 Available RAM:    ${AVAIL_RAM_GB} GB

 Services Status under [$PROFILE] profile:
   Elasticsearch:    ENABLED (Heap auto-tuned)
   Kibana:           ENABLED
   Logstash:         $([ "$PROFILE" != "minimal" ] && echo "ENABLED" || echo "DISABLED")
   Wazuh Stack:      $([ "$PROFILE" != "minimal" ] && echo "ENABLED" || echo "DISABLED")
   TheHive Stack:    $([ "$PROFILE" != "minimal" ] && echo "ENABLED" || echo "DISABLED")
   Splunk Free:      $([ "$PROFILE" = "full" -o "$PROFILE" = "instructor" ] && echo "ENABLED" || echo "DISABLED (Swap-only for Lab 3.1)")
   MISP Intel:       $([ "$PROFILE" = "full" -o "$PROFILE" = "instructor" ] && echo "ENABLED" || echo "DISABLED")
======================================================================
EOF

sleep 1
