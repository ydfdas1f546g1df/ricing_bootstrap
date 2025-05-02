#!/bin/bash
set -e

echo "
[*] Arch Linux Installer
[*] This script will install Arch Linux with a custom configuration."

# Check if enough free ram is available
if [ "$(free -m | awk '/^Mem:/{print $4}')" -lt 2048 ]; then
    echo "Not enough free RAM available. At least 2GB is required."
    exit 1
fi

# Install dependencies
echo "[*] Installing dependencies..."
pacman -Sy --noconfirm git


# Run the application
echo "[*] Running base installer..."
python base_install/main.py

echo "[*] Cloning repository..."
git clone https://github.com/ydfdas1f546g1df/ricing_bootstrap.git /mnt/root/ricing_bootstrap

echo "[*] Running post install..."
deactivate
