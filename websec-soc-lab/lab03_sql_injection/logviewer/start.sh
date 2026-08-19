#!/usr/bin/env bash
python3 viewer.py > viewer.log 2>&1 &
echo $! > viewer.pid
echo 'SOC Dashboard listening on http://0.0.0.0:8003'
