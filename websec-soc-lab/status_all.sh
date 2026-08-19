#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "========================================"
echo " MASTER LAB STATUS REPORT"
echo "========================================"

for lab_dir in lab*; do
    if [ -d "$lab_dir" ]; then
        (cd "$lab_dir/ubuntu_target" && ./status.sh)
    fi
done

echo "========================================"
