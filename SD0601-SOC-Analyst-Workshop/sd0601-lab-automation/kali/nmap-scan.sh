#!/usr/bin/env bash
# nmap-scan.sh — Controlled port scan script for Kali Linux in Lab 3.1 & Lab 6.1

TARGET="${1:-10.60.0.100}"
echo "[*] Executing controlled port scan against target: $TARGET"
nmap -sS -p 1-1000 -T4 "$TARGET"
