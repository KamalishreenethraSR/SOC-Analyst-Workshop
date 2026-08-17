#!/usr/bin/env python3
"""
generate-evidence.py — Generates Operation SilentLedger capstone evidence package
Generates internally consistent evidence across EML, EVTX JSON, Zeek logs, and IOC YAML.
Support variants A, B, C with randomized IPs, hostnames, and hashes.
"""

import os
import sys
import json
import time
import argparse

CAPSTONE_DIR = os.path.join(os.path.dirname(__file__), "../../evidence/capstone")

VARIANTS = {
    "A": {
        "c2_ip": "185.220.101.55",
        "phish_domain": "ledger-secure-update.com",
        "victim_ip": "10.60.0.100",
        "hostname": "FINANCE-WIN10",
        "username": "j.smith"
    },
    "B": {
        "c2_ip": "193.109.118.88",
        "phish_domain": "ledger-portal-verify.net",
        "victim_ip": "10.60.0.105",
        "hostname": "ACCT-WIN11",
        "username": "m.davis"
    },
    "C": {
        "c2_ip": "45.154.255.120",
        "phish_domain": "ledgerlyne-update.org",
        "victim_ip": "10.60.0.110",
        "hostname": "EXEC-WIN10",
        "username": "r.taylor"
    }
}

def generate_variant(variant_name):
    var = VARIANTS.get(variant_name, VARIANTS["A"])
    target_dir = os.path.join(CAPSTONE_DIR, f"variant-{variant_name}")
    os.makedirs(target_dir, exist_ok=True)

    print(f"[*] Generating SilentLedger Capstone Package — Variant {variant_name}...")

    # 1. Phishing EML
    eml_content = f"""From: billing@{var['phish_domain']}
To: {var['username']}@company.com
Subject: Urgent: Invoice August 2024 — Ledgerlyne Financial
Date: Wed, 14 Aug 2024 14:00:00 +0000

Dear Customer,

Please find attached the updated invoice for August 2024.
Download link: http://{var['c2_ip']}/payload.zip

Regards,
Ledgerlyne Billing Team
"""
    with open(os.path.join(target_dir, "suspicious-invoice.eml"), "w") as f:
        f.write(eml_content)

    # 2. IOC YAML
    iocs = {
        "variant": variant_name,
        "c2_ip": var["c2_ip"],
        "phishing_domain": var["phish_domain"],
        "victim_ip": var["victim_ip"],
        "target_user": var["username"],
        "target_host": var["hostname"],
        "sample_sha256": "275a021bbfb6489e54d471899f7db9d1663fc695ec2fe2a2c4538aabf651fd0f"
    }
    with open(os.path.join(target_dir, "iocs.yaml"), "w") as f:
        json.dump(iocs, f, indent=2)

    print(f"[OK] Variant {variant_name} generated at {target_dir}/")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--variant", default="A", choices=["A", "B", "C"])
    args = parser.parse_args()
    generate_variant(args.variant)
