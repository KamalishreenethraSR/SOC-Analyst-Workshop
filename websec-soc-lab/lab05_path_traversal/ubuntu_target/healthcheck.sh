#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "[+] Health checking Lab 05 — Path Traversal..."
curl -s http://127.0.0.1:6005/health || exit 1
echo ""
echo "[PASS] Health check successful."
