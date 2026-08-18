#!/bin/bash
# setup.sh - Configure FTP service and fail2ban for FTP Brute Force detection on Ubuntu target.

set -e

echo "[*] Configuring FTP service and Fail2ban telemetry..."

# Install vsftpd
if ! command -v vsftpd &> /dev/null; then
    echo "[*] Installing vsftpd..."
    sudo apt-get update -y
    sudo apt-get install -y vsftpd
fi

# Configure vsftpd
echo "[*] Configuring vsftpd settings..."
sudo tee /etc/vsftpd.conf > /dev/null << 'EOF'
listen=NO
listen_ipv6=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_file=/var/log/vsftpd.log
xferlog_std_format=NO
log_ftp_protocol=YES
syslog_enable=NO
EOF

# Ensure fail2ban is installed
if ! command -v fail2ban-client &> /dev/null; then
    echo "[*] Installing Fail2ban..."
    sudo apt-get install -y fail2ban
fi

# Create custom Fail2ban jail for FTP
echo "[*] Writing custom Fail2ban jail configuration for FTP..."
cat << 'EOF' | sudo tee /etc/fail2ban/jail.d/vsftpd.local > /dev/null
[vsftpd]
enabled = true
port = ftp,ftp-data,ftps,ftps-data
filter = vsftpd
logpath = /var/log/vsftpd.log
maxretry = 5
bantime = 10m
EOF

# Enable and restart services
sudo systemctl enable vsftpd || true
sudo systemctl restart vsftpd || true
sudo systemctl restart fail2ban || true

echo "[+] Target environment setup complete for FTP Brute Force detection."
