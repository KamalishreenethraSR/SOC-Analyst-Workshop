#!/usr/bin/env bash
# lib-logging.sh — Structured, color-coded logging library for SD0601 automation

LOG_DIR="${SCRIPT_DIR:-.}/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/automation.log"

# Colors
COLOR_RESET="\e[0m"
COLOR_INFO="\e[34m"
COLOR_OK="\e[32m"
COLOR_WARN="\e[33m"
COLOR_ERROR="\e[31m"
COLOR_HEADER="\e[35m"

_timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

log_info() {
    local msg="$*"
    echo -e "${COLOR_INFO}[INFO] $(_timestamp) — ${msg}${COLOR_RESET}"
    echo "INFO [$(_timestamp)] ${msg}" >> "$LOG_FILE"
}

log_ok() {
    local msg="$*"
    echo -e "${COLOR_OK}[OK]   ($(_timestamp)) — ${msg}${COLOR_RESET}"
    echo "OK   [$(_timestamp)] ${msg}" >> "$LOG_FILE"
}

log_warn() {
    local msg="$*"
    echo -e "${COLOR_WARN}[WARN] ($(_timestamp)) — ${msg}${COLOR_RESET}"
    echo "WARN [$(_timestamp)] ${msg}" >> "$LOG_FILE"
}

log_error() {
    local msg="$*"
    echo -e "${COLOR_ERROR}[ERR]  ($(_timestamp)) — ${msg}${COLOR_RESET}" >&2
    echo "ERR  [$(_timestamp)] ${msg}" >> "$LOG_FILE"
}

log_header() {
    local msg="$*"
    echo -e "\n${COLOR_HEADER}======================================================================${COLOR_RESET}"
    echo -e "${COLOR_HEADER} ${msg} ${COLOR_RESET}"
    echo -e "${COLOR_HEADER}======================================================================${COLOR_RESET}"
    echo "HEADER [$(_timestamp)] === ${msg} ===" >> "$LOG_FILE"
}
