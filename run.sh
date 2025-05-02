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

echo "[*] Creating virtual environment..."
python -m venv .venv
source .venv/bin/activate

echo "[*] Installing locked archinstall version..."
pip install archinstall==2.8.3


# Run the application
echo "[*] Running base installer..."
python base_install/main.py

echo "[*] Running post install..."
deactivate
