#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "========================================"
echo " STARTING LAB TARGET: Lab 10 — WAF Investigation"
echo "========================================"

python3 app.py > app.log 2>&1 &
APP_PID=$!
echo $APP_PID > app.pid

python3 waf.py > waf.log 2>&1 &
WAF_PID=$!
echo $WAF_PID > waf.pid

sleep 2
echo "Application Port : http://0.0.0.0:5010"
echo "WAF Proxy Port   : http://0.0.0.0:6010"
echo "STATUS           : RUNNING"
echo "========================================"
