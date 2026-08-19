#!/usr/bin/env bash
set -e

echo "========================================"
echo " MASTER LAB SETUP"
echo "========================================"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "[1/4] Checking Python environment..."
python3 --version

echo "[2/4] Checking Python dependencies..."
python3 -c "import flask, requests; print('Flask and Requests installed!')" 2>/dev/null || {
    echo "[!] Installing dependencies..."
    pip install flask requests || pip3 install flask requests
}

echo "[3/4] Initializing all 10 independent labs..."
for lab_dir in lab*; do
    if [ -d "$lab_dir" ]; then
        echo "  -> Preparing $lab_dir..."
        (cd "$lab_dir/ubuntu_target" && ./setup.sh)
        (cd "$lab_dir/logviewer" && ./setup.sh)
        (cd "$lab_dir/attacker_kali" && ./setup.sh)
    fi
done

echo "[4/4] Setting permissions for shell scripts..."
find . -type f -name "*.sh" -exec chmod +x {} +

echo "========================================"
echo " MASTER LAB SETUP COMPLETE"
echo "========================================"
