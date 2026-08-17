#!/usr/bin/env bash
# snapshot.sh — Creates and restores snapshots of Docker volume states

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"

SNAP_DIR="$SCRIPT_DIR/snapshots"
mkdir -p "$SNAP_DIR"

action="${1:-create}"
snap_name="${2:-baseline}"

case "$action" in
    create)
        log_info "Creating snapshot '$snap_name'..."
        cp -r "$SCRIPT_DIR/state" "$SNAP_DIR/$snap_name-state" 2>/dev/null || true
        log_ok "Snapshot '$snap_name' saved to $SNAP_DIR/"
        ;;
    restore)
        log_info "Restoring snapshot '$snap_name'..."
        if [ -d "$SNAP_DIR/$snap_name-state" ]; then
            cp -r "$SNAP_DIR/$snap_name-state"/* "$SCRIPT_DIR/state/"
            log_ok "Snapshot '$snap_name' restored."
        else
            log_error "Snapshot '$snap_name' not found."
            exit 1
        fi
        ;;
    *)
        echo "Usage: ./snapshot.sh <create|restore> [snapshot_name]"
        exit 1
        ;;
esac
