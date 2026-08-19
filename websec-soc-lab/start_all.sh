#!/usr/bin/env bash

echo "========================================"
echo " STARTING ALL LAB SERVICES"
echo "========================================"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

for lab_dir in lab*; do
    if [ -d "$lab_dir" ]; then
        echo "  -> Starting services in $lab_dir..."
        (cd "$lab_dir/ubuntu_target" && ./start.sh)
        (cd "$lab_dir/logviewer" && ./start.sh)
    fi
done

echo "========================================"
echo " ALL LAB SERVICES STARTED"
echo "========================================"
