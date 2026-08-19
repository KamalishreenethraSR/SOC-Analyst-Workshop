#!/usr/bin/env bash

echo "========================================"
echo " STOPPING ALL LAB SERVICES"
echo "========================================"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

for lab_dir in lab*; do
    if [ -d "$lab_dir" ]; then
        echo "  -> Stopping services in $lab_dir..."
        (cd "$lab_dir/ubuntu_target" && ./stop.sh)
        (cd "$lab_dir/logviewer" && ./stop.sh)
    fi
done

echo "========================================"
echo " ALL LAB SERVICES STOPPED"
echo "========================================"
