#!/usr/bin/env bash
set -e
echo "[+] Setting up Ubuntu Target for Lab 03 — SQL Injection..."
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

python3 database.py
mkdir -p lab_files
echo "Setup complete for Lab 03 — SQL Injection."
