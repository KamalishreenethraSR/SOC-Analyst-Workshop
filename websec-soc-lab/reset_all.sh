#!/usr/bin/env bash

echo "========================================"
echo " RESETTING ALL LAB DATABASES & LOGS"
echo "========================================"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

for lab_dir in lab*; do
    if [ -d "$lab_dir" ]; then
        echo "  -> Resetting $lab_dir..."
        (cd "$lab_dir/ubuntu_target" && ./reset.sh)
    fi
done

echo "========================================"
echo " ALL LABS RESET COMPLETE"
echo "========================================"
