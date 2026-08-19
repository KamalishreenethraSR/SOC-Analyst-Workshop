#!/usr/bin/env bash

LAB_ARG="$1"

if [ -z "$LAB_ARG" ]; then
    echo "Usage: ./run_lab.sh <LAB_NUMBER_OR_NAME>"
    echo "Example: ./run_lab.sh 03  or  ./run_lab.sh lab03_sql_injection"
    exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

# Resolve lab directory name
LAB_DIR=""
if [ -d "$LAB_ARG" ]; then
    LAB_DIR="$LAB_ARG"
else
    LAB_DIR=$(ls -d lab${LAB_ARG}* 2>/dev/null | head -n 1 || true)
fi

if [ -z "$LAB_DIR" ] || [ ! -d "$LAB_DIR" ]; then
    echo "[!] Error: Lab matching '$LAB_ARG' not found."
    exit 1
fi

echo "========================================"
echo " RUNNING SINGLE LAB ORCHESTRATION"
echo " Target Lab: $LAB_DIR"
echo "========================================"

echo "[1/4] Starting target services..."
(cd "$LAB_DIR/ubuntu_target" && ./start.sh)
(cd "$LAB_DIR/logviewer" && ./start.sh)

sleep 2

echo "[2/4] Verifying health..."
(cd "$LAB_DIR/ubuntu_target" && ./healthcheck.sh)

echo "[3/4] Executing Kali attack simulation..."
(cd "$LAB_DIR/attacker_kali" && ./attack.sh)

sleep 1

echo "[4/4] Verifying SOC events logged..."
(cd "$LAB_DIR/logviewer" && ./verify.sh)

echo "========================================"
echo " LAB $LAB_DIR ORCHESTRATION COMPLETE"
echo " Log Viewer Dashboard URL:"
(cd "$LAB_DIR/logviewer" && cat viewer.log | grep listening || true)
echo "========================================"
