#!/usr/bin/env bash
# lib-credentials.sh — Loads and manages secret environment variables securely

ENV_FILE="${SCRIPT_DIR:-.}/.env"
ENV_EXAMPLE="${SCRIPT_DIR:-.}/.env.example"

load_credentials() {
    if [ ! -f "$ENV_FILE" ]; then
        if [ -f "$ENV_EXAMPLE" ]; then
            cp "$ENV_EXAMPLE" "$ENV_FILE"
            log_warn "Created default .env from .env.example"
        else
            cat << 'EOF' > "$ENV_FILE"
ELASTIC_PASSWORD=changeme
SPLUNK_PASSWORD=changeme
WAZUH_API_PASSWORD=wazuh
MISP_ADMIN_PASS=admin
THEHIVE_ADMIN_PASS=secret
EOF
            log_info "Generated initial .env file"
        fi
    fi

    # Export variables safely
    set -o allexport
    source "$ENV_FILE"
    set +o allexport
}
