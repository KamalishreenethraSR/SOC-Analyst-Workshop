#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "=== Target Status for Lab 08 — Parameter Tampering ==="
if pgrep -f "lab08_parameter_tampering/ubuntu_target/app.py" >/dev/null || pgrep -f "port 5008" >/dev/null; then echo "[OK] Flask Application running"; else echo "[!] Flask Application stopped"; fi
if pgrep -f "lab08_parameter_tampering/ubuntu_target/waf.py" >/dev/null || pgrep -f "port 6008" >/dev/null; then echo "[OK] WAF Proxy running"; else echo "[!] WAF Proxy stopped"; fi
