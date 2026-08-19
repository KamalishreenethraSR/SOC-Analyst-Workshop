#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "=== Target Status for Lab 02 — Reconnaissance ==="
if pgrep -f "lab02_reconnaissance/ubuntu_target/app.py" >/dev/null || pgrep -f "port 5002" >/dev/null; then echo "[OK] Flask Application running"; else echo "[!] Flask Application stopped"; fi
if pgrep -f "lab02_reconnaissance/ubuntu_target/waf.py" >/dev/null || pgrep -f "port 6002" >/dev/null; then echo "[OK] WAF Proxy running"; else echo "[!] WAF Proxy stopped"; fi
