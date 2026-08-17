#!/usr/bin/env bash
# lib-utils.sh — Helper utilities (wait for port, retry command, check dependencies)

wait_for_port() {
    local host="$1"
    local port="$2"
    local timeout="${3:-30}"
    local count=0

    log_info "Waiting for TCP $host:$port (timeout: ${timeout}s)..."
    while ! nc -z "$host" "$port" 2>/dev/null && [ "$count" -lt "$timeout" ]; do
        sleep 1
        count=$((count + 1))
    done

    if [ "$count" -ge "$timeout" ]; then
        log_error "Timed out waiting for $host:$port"
        return 1
    fi
    log_ok "$host:$port is open."
    return 0
}

wait_for_http() {
    local url="$1"
    local expected_code="${2:-200}"
    local timeout="${3:-30}"
    local count=0

    log_info "Waiting for HTTP $url (timeout: ${timeout}s)..."
    while [ "$count" -lt "$timeout" ]; do
        local code
        code=$(curl -sk -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
        if [ "$code" -eq "$expected_code" ] || [ "$code" -eq 401 ] || [ "$code" -eq 302 ]; then
            log_ok "HTTP $url responded with status code $code."
            return 0
        fi
        sleep 2
        count=$((count + 2))
    done

    log_warn "HTTP $url check reached timeout (code: $code)."
    return 1
}

retry_cmd() {
    local max_attempts="$1"
    local delay="$2"
    shift 2

    local attempt=1
    until "$@"; do
        if [ "$attempt" -ge "$max_attempts" ]; then
            log_error "Command failed after $max_attempts attempts: $*"
            return 1
        fi
        log_warn "Command failed (attempt $attempt/$max_attempts). Retrying in ${delay}s..."
        sleep "$delay"
        attempt=$((attempt + 1))
    done
    return 0
}

check_tool() {
    local tool="$1"
    if ! command -v "$tool" &>/dev/null; then
        log_error "Required tool '$tool' is not installed."
        return 1
    fi
    return 0
}
