#!/usr/bin/env bash
if [ -f viewer.pid ]; then kill -9 $(cat viewer.pid) 2>/dev/null || true; rm viewer.pid; fi
pkill -f 'lab01_http_baseline/logviewer/viewer.py' 2>/dev/null || true
