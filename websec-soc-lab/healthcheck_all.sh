#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "========================================"
echo " RUNNING HEALTH CHECKS ACROSS ALL LABS"
echo "========================================"

FAILED=0

for lab_dir in lab*; do
    if [ -d "$lab_dir" ]; then
        echo "Testing $lab_dir..."
        if (cd "$lab_dir/ubuntu_target" && ./healthcheck.sh >/dev/null 2>&1); then
            echo "  [PASS] $lab_dir target healthy"
        else
            echo "  [FAIL] $lab_dir target offline"
            FAILED=$((FAILED+1))
        fi
    fi
done

echo "========================================"
if [ $FAILED -eq 0 ]; then
    echo " ALL LABS PASSED HEALTH CHECK!"
else
    echo " [!] $FAILED labs failed health check. Start labs using ./start_all.sh"
fi
echo "========================================"
