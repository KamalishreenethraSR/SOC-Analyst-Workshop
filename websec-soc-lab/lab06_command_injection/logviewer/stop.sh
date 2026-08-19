#!/usr/bin/env bash
if [ -f viewer.pid ]; then kill -9 $(cat viewer.pid) 2>/dev/null || true; rm viewer.pid; fi
pkill -f 'lab06_command_injection/logviewer/viewer.py' 2>/dev/null || true
