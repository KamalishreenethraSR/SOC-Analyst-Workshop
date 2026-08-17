#!/usr/bin/env bash
# ==============================================================================
# SD0601 — SOC Analyst Workshop Automation Controller
# ==============================================================================
# Orchestrates Docker host, SIEM stacks, lab setup, health checks, & verification.
# Safe, isolated, platform-aware, and RAM-profile aware.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTOMATION_DIR="$SCRIPT_DIR/automation"

# Source core libraries
source "$AUTOMATION_DIR/core/lib-logging.sh"
source "$AUTOMATION_DIR/core/lib-state.sh"
source "$AUTOMATION_DIR/core/lib-utils.sh"
source "$AUTOMATION_DIR/core/lib-config.sh"
source "$AUTOMATION_DIR/core/lib-credentials.sh"

show_help() {
    cat << 'EOF'
SD0601 SOC Analyst Lab Automation System
Usage: ./sd0601.sh <command> [subcommand/options]

Core Commands:
  install [--profile P] [--offline]   Run preflight and install Docker SOC stack
  start                               Start all configured Docker services
  stop                                Stop all running Docker services
  restart                             Restart Docker services
  status                              Quick service status overview
  health                              Run comprehensive course-wide health check
  course verify                       Validate full course infrastructure

Lab Commands:
  lab list                            List all labs and their current state
  lab setup <1.1|2.1|3.1|4.1|5.1|6.1>  Prepare environment for specific lab
  lab verify <1.1|2.1|3.1|4.1|5.1|6.1> Run verification tests for specific lab
  lab reset <1.1|2.1|3.1|4.1|5.1|6.1> Restores lab to clean baseline state

Day Commands:
  day setup <1|2|3|4|5>              Prepare infrastructure required for specific day
  day reset <1|2|3|4|5>              Reset specific day's lab environments

Capstone Commands:
  capstone prepare [--variant A|B|C]   Generate SilentLedger evidence package
  capstone verify                     Verify capstone evidence integrity

System & Readiness Commands:
  student readiness                   Perform quick student pre-lab readiness check
  instructor readiness                Perform deep instructor environment check
  snapshot create                     Create backup of Docker volumes & state
  snapshot restore                    Restore Docker volumes & state from snapshot
  logs [component]                    View system or component logs
  cleanup                             Clean lab telemetry/data while keeping tools
  destroy                             Completely tear down Docker stacks and data
EOF
}

# Main command dispatcher
main() {
    init_state
    load_credentials

    local cmd="${1:-help}"
    shift || true

    case "$cmd" in
        install)
            "$AUTOMATION_DIR/preflight.sh" "$@"
            "$AUTOMATION_DIR/network.sh"
            "$AUTOMATION_DIR/docker/deploy-all.sh" "$@"
            "$AUTOMATION_DIR/siem/load-detections.sh"
            "$AUTOMATION_DIR/datasets/load-datasets.sh"
            log_ok "Installation phase completed successfully."
            ;;
        start)
            log_info "Starting Docker SOC services..."
            docker compose -f "$SCRIPT_DIR/infrastructure/docker/full-stack/docker-compose.yml" start
            log_ok "Services started."
            ;;
        stop)
            log_info "Stopping Docker SOC services..."
            docker compose -f "$SCRIPT_DIR/infrastructure/docker/full-stack/docker-compose.yml" stop
            log_ok "Services stopped."
            ;;
        restart)
            log_info "Restarting Docker SOC services..."
            docker compose -f "$SCRIPT_DIR/infrastructure/docker/full-stack/docker-compose.yml" restart
            log_ok "Services restarted."
            ;;
        status)
            log_info "Docker Container Status:"
            docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
            ;;
        health)
            "$AUTOMATION_DIR/verification/health-check.sh"
            ;;
        course)
            if [ "${1:-}" = "verify" ]; then
                "$AUTOMATION_DIR/verification/health-check.sh" --deep
            else
                log_error "Unknown course command. Did you mean: ./sd0601.sh course verify?"
            fi
            ;;
        lab)
            local subcmd="${1:-list}"
            shift || true
            case "$subcmd" in
                list)
                    show_lab_list
                    ;;
                setup)
                    local lab_id="${1:-}"
                    if [ -z "$lab_id" ]; then
                        log_error "Specify lab ID (e.g., 1.1, 2.1, 3.1, 4.1, 5.1, 6.1)"
                        exit 1
                    fi
                    local lab_fmt="${lab_id//./-}"
                    log_info "Setting up Lab $lab_id..."
                    "$SCRIPT_DIR/labs/module-0$(echo $lab_id | cut -d. -f1)/lab-$lab_id/setup.sh" "$@"
                    ;;
                verify)
                    local lab_id="${1:-}"
                    if [ -z "$lab_id" ]; then
                        log_error "Specify lab ID (e.g., 1.1, 2.1, 3.1, 4.1, 5.1, 6.1)"
                        exit 1
                    fi
                    log_info "Verifying Lab $lab_id..."
                    "$AUTOMATION_DIR/verification/verify-lab-${lab_id//./-}.sh" "$@"
                    ;;
                reset)
                    local lab_id="${1:-}"
                    if [ -z "$lab_id" ]; then
                        log_error "Specify lab ID (e.g., 1.1, 2.1, 3.1, 4.1, 5.1, 6.1)"
                        exit 1
                    fi
                    log_info "Resetting Lab $lab_id..."
                    "$SCRIPT_DIR/labs/module-0$(echo $lab_id | cut -d. -f1)/lab-$lab_id/reset.sh" "$@"
                    ;;
                *)
                    log_error "Unknown lab subcommand: $subcmd"
                    exit 1
                    ;;
            esac
            ;;
        day)
            local subcmd="${1:-}"
            local day_num="${2:-}"
            if [ "$subcmd" = "setup" ] && [ -n "$day_num" ]; then
                log_info "Setting up environment for Day $day_num..."
                case "$day_num" in
                    1) "$0" lab setup 1.1 ;;
                    2) "$0" lab setup 2.1 ;;
                    3) "$0" lab setup 3.1 ;;
                    4) "$0" lab setup 4.1 ;;
                    5) "$0" lab setup 5.1; "$0" lab setup 6.1 ;;
                    *) log_error "Invalid day: $day_num (1-5)"; exit 1 ;;
                esac
            elif [ "$subcmd" = "reset" ] && [ -n "$day_num" ]; then
                log_info "Resetting Day $day_num..."
                case "$day_num" in
                    1) "$0" lab reset 1.1 ;;
                    2) "$0" lab reset 2.1 ;;
                    3) "$0" lab reset 3.1 ;;
                    4) "$0" lab reset 4.1 ;;
                    5) "$0" lab reset 5.1; "$0" lab reset 6.1 ;;
                    *) log_error "Invalid day: $day_num (1-5)"; exit 1 ;;
                esac
            else
                log_error "Usage: ./sd0601.sh day <setup|reset> <day_number>"
                exit 1
            fi
            ;;
        capstone)
            local subcmd="${1:-prepare}"
            shift || true
            if [ "$subcmd" = "prepare" ]; then
                python3 "$AUTOMATION_DIR/capstone/generate-evidence.py" "$@"
            elif [ "$subcmd" = "verify" ]; then
                "$AUTOMATION_DIR/verification/verify-capstone.sh" "$@"
            else
                log_error "Unknown capstone command: $subcmd"
                exit 1
            fi
            ;;
        student)
            if [ "${1:-}" = "readiness" ]; then
                log_info "Running Student Readiness Check..."
                "$AUTOMATION_DIR/verification/health-check.sh" --student
            else
                log_error "Unknown student command. Did you mean: ./sd0601.sh student readiness?"
            fi
            ;;
        instructor)
            if [ "${1:-}" = "readiness" ]; then
                log_info "Running Instructor Readiness Check..."
                "$AUTOMATION_DIR/verification/health-check.sh" --instructor
            else
                log_error "Unknown instructor command. Did you mean: ./sd0601.sh instructor readiness?"
            fi
            ;;
        snapshot)
            "$AUTOMATION_DIR/snapshot.sh" "$@"
            ;;
        cleanup)
            log_info "Cleaning up temporary lab telemetry..."
            rm -rf "$SCRIPT_DIR/logs/"*.log "$SCRIPT_DIR/datasets/synthetic/"*.tmp
            log_ok "Cleanup complete."
            ;;
        destroy)
            log_warn "Tearing down all Docker SOC services and network..."
            docker compose -f "$SCRIPT_DIR/infrastructure/docker/full-stack/docker-compose.yml" down -v --remove-orphans || true
            docker network rm soc-lab 2>/dev/null || true
            log_ok "Stack destroyed."
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

show_lab_list() {
    cat << 'EOF'
======================================================================
 SD0601 LAB STATUS & SUMMARY
======================================================================
 Lab 1.1 — ATT&CK Mapping & Ticket Triage
   Focus: MITRE ATT&CK taxonomy, SOC ticket lifecycle, escalation matrix
   Target: Browser / Local workspace

 Lab 2.1 — Log Pipeline: Endpoint to SIEM
   Focus: Sysmon, Winlogbeat, Filebeat, auditd, Elasticsearch & Kibana
   Target: Windows VM, Ubuntu VM, Docker Host

 Lab 3.1 — SIEM Build-Out and Detection Engineering
   Focus: Splunk Free, Kibana KQL, SPL queries, alerts, dashboards
   Target: Docker Host (Splunk + ELK)

 Lab 4.1 — IOC Enrichment, YARA, and Full Case Lifecycle
   Focus: TheHive 5, Cortex, MISP, YARA analysis
   Target: Docker Host (TheHive stack)

 Lab 5.1 — Endpoint Detection, Threat Hunt, and Memory Triage
   Focus: Wazuh EDR, Linux auditd, Volatility 3 memory triage
   Target: Windows VM, Ubuntu VM, Analyst Laptop

 Lab 6.1 — Atomic Red Team Live-Fire Detection Drill
   Focus: Atomic Red Team execution, real-time alert triage, SLA tracking
   Target: Windows VM, Docker Host (SIEM/Wazuh/TheHive)
======================================================================
EOF
}

main "$@"
