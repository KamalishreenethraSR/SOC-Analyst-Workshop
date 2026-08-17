#!/usr/bin/env bash
# ==============================================================================
# SD0601 — Kali Linux Attacker Setup Script
# ==============================================================================
# Configures Kali Linux Attacker VM (10.60.0.200) for controlled lab drills.
# Ensures tools (nmap, hydra, curl) and lab scripts are ready.
# ==============================================================================

set -euo pipefail

log_info() { echo -e "\e[34m[INFO]\e[0m $*"; }
log_ok()   { echo -e "\e[32m[OK]\e[0m $*"; }
log_warn() { echo -e "\e[33m[WARN]\e[0m $*"; }

log_info "Bootstrapping Kali Linux Attacker VM for SD0601 Lab Drills..."

# Ensure required packages are present
sudo apt-get update -qq && sudo apt-get install -y -qq nmap hydra curl jq &>/dev/null || true

log_ok "Kali tools (nmap, hydra, curl, jq) verified."
log_info "Kali Attacker IP: 10.60.0.200 (Target VM: 10.60.0.100 / Ubuntu VM: 10.60.0.101)"

cat << 'EOF'
======================================================================
 KALI LINUX RED TEAM QUICK COMMANDS
======================================================================
 1. Port Scan Target (Lab 3.1):
    ./nmap-scan.sh 10.60.0.100

 2. SSH Brute Force Test (Lab 2.1 / Lab 6.1):
    ./ssh-bruteforce.sh 10.60.0.101
======================================================================
EOF
