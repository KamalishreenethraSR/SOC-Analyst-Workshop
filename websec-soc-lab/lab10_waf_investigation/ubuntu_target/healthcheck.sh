#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "[+] Health checking Lab 10 — WAF Investigation..."
curl -s http://127.0.0.1:6010/health || exit 1
echo ""
echo "[PASS] Health check successful."
