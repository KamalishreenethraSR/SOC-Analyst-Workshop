#!/bin/bash
# setup.sh - Configure SSH logging and fail2ban for SSH Brute Force detection on Ubuntu target.

set -e

echo "[*] Configuring SSH authentication and Fail2ban telemetry..."

# Ensure openssh-server is installed
if ! command -v sshd &> /dev/null; then
    echo "[*] Installing OpenSSH Server..."
    sudo apt-get update -y
    sudo apt-get install -y openssh-server
fi

# Ensure fail2ban is installed
if ! command -v fail2ban-client &> /dev/null; then
    echo "[*] Installing Fail2ban..."
    sudo apt-get install -y fail2ban
fi

# Set SSHD configuration to Verbose logging
echo "[*] Setting SSHD LogLevel to VERBOSE..."
sudo sed -i 's/#LogLevel INFO/LogLevel VERBOSE/g' /etc/ssh/sshd_config
sudo sed -i 's/LogLevel INFO/LogLevel VERBOSE/g' /etc/ssh/sshd_config

# Create a local custom jail for SSH
echo "[*] Writing custom Fail2ban jail configuration..."
cat << 'EOF' | sudo tee /etc/fail2ban/jail.local > /dev/null
[DEFAULT]
bantime = 10m
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
EOF

# Enable and restart services
sudo systemctl enable ssh || true
sudo systemctl restart ssh || true
sudo systemctl enable fail2ban || true
sudo systemctl restart fail2ban || true

echo "[+] Target environment setup complete for SSH Brute Force detection."
