#!/usr/bin/env bash
# load-datasets.sh — Generates and verifies safe synthetic datasets

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/automation/core/lib-logging.sh"

log_header "GENERATING & LOADING SYNTHETIC DATASETS"

python3 "$SCRIPT_DIR/automation/datasets/generate-synthetic.py"

log_ok "All training datasets generated and verified."
