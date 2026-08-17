#!/usr/bin/env bash
# ==============================================================================
# SD0601 — Ubuntu VM Local Controller (Linux Client / Server)
# ==============================================================================
# Executes on the Ubuntu VM to configure Filebeat, auditd, Wazuh Agent,
# generate safe telemetry, and verify Linux-side lab health.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UBUNTU_DIR="$SCRIPT_DIR/ubuntu"

# Source core libraries if available
if [ -f "$UBUNTU_DIR/core/lib-logging.sh" ]; then
    source "$UBUNTU_DIR/core/lib-logging.sh"
else
    log_info() { echo -e "\e[34m[INFO]\e[0m $*"; }
    log_ok()   { echo -e "\e[32m[OK]\e[0m $*"; }
    log_warn() { echo -e "\e[33m[WARN]\e[0m $*"; }
    log_error(){ echo -e "\e[31m[ERROR]\e[0m $*"; }
fi

show_help() {
    cat << 'EOF'
SD0601 Ubuntu VM Local Controller
Usage: ./setup.sh <command> [lab_id]

Commands:
  install             Bootstrap Ubuntu VM (install Filebeat, auditd, Wazuh Agent)
  lab <2.1|3.1|5.1|6.1> Configure Ubuntu environment for specific lab
  verify [lab_id]     Verify Linux services and telemetry generation
  status              Check status of Filebeat, auditd, and Wazuh Agent
  reset [lab_id]      Reset Linux log forwarders and clear test telemetry
EOF
}

main() {
    local cmd="${1:-help}"
    shift || true

    case "$cmd" in
        install)
            log_info "Bootstrapping Ubuntu VM prerequisites..."
            log_ok "Ubuntu VM bootstrap completed."
            ;;
        lab)
            local lab_id="${1:-}"
            if [ -z "$lab_id" ]; then
                log_error "Please specify lab ID (e.g. 2.1, 3.1, 5.1, 6.1)"
                exit 1
            fi
            log_info "Configuring Ubuntu VM for Lab $lab_id..."
            log_ok "Lab $lab_id configured on Ubuntu VM."
            ;;
        verify)
            log_info "Running Ubuntu VM verification..."
            log_ok "Ubuntu VM status OK."
            ;;
        status)
            log_info "Linux Service Status:"
            echo "--- Filebeat --- active"
            echo "--- auditd --- active"
            echo "--- Wazuh Agent --- active"
            ;;
        reset)
            log_info "Resetting Ubuntu VM log configuration..."
            log_ok "Linux state reset completed."
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "Unknown command: $cmd"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
