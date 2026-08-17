#!/usr/bin/env bash
# deploy-all.sh — Deploys Docker stacks based on selected RAM profile

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"
source "$SCRIPT_DIR/automation/core/lib-state.sh"

log_header "DEPLOYING DOCKER SOC STACKS"

PROFILE=$(python3 -c "import json; data=json.load(open('$SCRIPT_DIR/state/course-state.json')); print(data.get('profile','standard'))" 2>/dev/null || echo "standard")

log_info "Deploying Docker stacks under profile: [$PROFILE]"

# Always deploy ELK
log_info "1/4 Deploying ELK Stack..."
docker compose -f "$SCRIPT_DIR/infrastructure/docker/elk/docker-compose.yml" up -d

if [ "$PROFILE" != "minimal" ]; then
    log_info "2/4 Deploying Wazuh Stack..."
    docker compose -f "$SCRIPT_DIR/infrastructure/docker/wazuh/docker-compose.yml" up -d

    log_info "3/4 Deploying TheHive Stack..."
    docker compose -f "$SCRIPT_DIR/infrastructure/docker/thehive/docker-compose.yml" up -d
else
    log_warn "Skipping Wazuh & TheHive under MINIMAL profile."
fi

if [ "$PROFILE" = "full" ] || [ "$PROFILE" = "instructor" ]; then
    log_info "4/4 Deploying Splunk & MISP..."
    docker compose -f "$SCRIPT_DIR/infrastructure/docker/splunk/docker-compose.yml" up -d
    docker compose -f "$SCRIPT_DIR/infrastructure/docker/misp/docker-compose.yml" up -d
else
    log_info "Skipping Splunk & MISP under $PROFILE profile (can be started on-demand)."
fi

set_course_state "True" "$PROFILE"
log_ok "Docker SOC stack deployment phase completed."
