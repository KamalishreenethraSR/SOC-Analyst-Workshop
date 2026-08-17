#!/usr/bin/env bash
# lib-config.sh — Reads YAML config values using Python 3 fallback parser

get_config_val() {
    local yaml_file="$1"
    local key_path="$2"
    local default_val="${3:-}"

    if [ ! -f "$yaml_file" ]; then
        echo "$default_val"
        return
    fi

    python3 -c "
import sys, yaml
try:
    with open('$yaml_file') as f:
        data = yaml.safe_load(f)
    keys = '$key_path'.split('.')
    val = data
    for k in keys:
        val = val[k]
    print(val if val is not None else '$default_val')
except Exception:
    print('$default_val')
" 2>/dev/null || echo "$default_val"
}
