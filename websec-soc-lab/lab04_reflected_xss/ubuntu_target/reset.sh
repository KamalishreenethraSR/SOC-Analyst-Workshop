#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

./stop.sh
rm -f security.db waf.log app.log
python3 database.py
echo "[+] Database and log files reset for Lab 04 — Reflected XSS."
