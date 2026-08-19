#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "=== Target Status for Lab 01 — HTTP Baseline ==="
if pgrep -f "lab01_http_baseline/ubuntu_target/app.py" >/dev/null || pgrep -f "port 5001" >/dev/null; then echo "[OK] Flask Application running"; else echo "[!] Flask Application stopped"; fi
if pgrep -f "lab01_http_baseline/ubuntu_target/waf.py" >/dev/null || pgrep -f "port 6001" >/dev/null; then echo "[OK] WAF Proxy running"; else echo "[!] WAF Proxy stopped"; fi
