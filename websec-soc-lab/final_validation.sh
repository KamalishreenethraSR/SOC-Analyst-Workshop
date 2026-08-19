#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "========================================"
echo " END-TO-END FINAL LAB VALIDATION"
echo "========================================"

echo "[+] Step 1: Stopping existing lab processes..."
./stop_all.sh >/dev/null 2>&1 || true

echo "[+] Step 2: Running master setup..."
./setup_all.sh

echo "[+] Step 3: Starting all services..."
./start_all.sh

sleep 3

TOTAL_LABS=0
PASSED_LABS=0

echo "[+] Step 4: Testing attack-to-detection workflow for all labs..."
for lab_dir in lab*; do
    if [ -d "$lab_dir" ]; then
        TOTAL_LABS=$((TOTAL_LABS+1))
        echo "----------------------------------------"
        echo " Validating: $lab_dir"
        
        # Execute Kali attack simulation
        (cd "$lab_dir/attacker_kali" && ./attack.sh >/dev/null 2>&1) || true
        
        # Verify SOC events logged
        if (cd "$lab_dir/logviewer" && ./verify.sh >/dev/null 2>&1); then
            echo "  [PASS] $lab_dir — Attack detected & SOC event generated!"
            PASSED_LABS=$((PASSED_LABS+1))
        else
            echo "  [FAIL] $lab_dir — SOC verification failed."
        fi
    fi
done

echo "========================================"
echo " FINAL VALIDATION SUMMARY"
echo "========================================"
echo " Total Labs Tested : $TOTAL_LABS"
echo " Passed Labs       : $PASSED_LABS"
echo " Failed Labs       : $((TOTAL_LABS-PASSED_LABS))"

if [ $PASSED_LABS -eq $TOTAL_LABS ]; then
    echo " RESULT            : ALL LABS VALIDATED SUCCESSFULLY!"
else
    echo " RESULT            : SOME LABS FAILED VALIDATION"
fi
echo "========================================"
