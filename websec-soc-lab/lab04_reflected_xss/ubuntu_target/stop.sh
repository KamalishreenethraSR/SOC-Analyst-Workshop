#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "[+] Stopping Lab 04 — Reflected XSS Target services..."
if [ -f app.pid ]; then
    kill -9 $(cat app.pid) 2>/dev/null || true
    rm app.pid
fi
if [ -f waf.pid ]; then
    kill -9 $(cat waf.pid) 2>/dev/null || true
    rm waf.pid
fi
# Safely kill only processes running in this lab directory
pkill -f "lab04_reflected_xss/ubuntu_target/app.py" 2>/dev/null || true
pkill -f "lab04_reflected_xss/ubuntu_target/waf.py" 2>/dev/null || true
echo "[+] Services stopped."
