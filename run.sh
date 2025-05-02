#!/bin/bash
set -e

echo "
[*] Arch Linux Installer
[*] This script will install Arch Linux with a custom configuration."


# Install dependencies
echo "[*] Installing dependencies..."
pacman -Sy --noconfirm git

# Generate the Archinstall config
echo "[*] Generating Archinstall config..."
./base_install/generate_archinstall_config.sh

# Run the application
echo "[*] Running base installer..."

echo "[*] Cloning repository..."
git clone https://github.com/ydfdas1f546g1df/ricing_bootstrap.git /mnt/root/ricing_bootstrap

echo "[*] Running post install..."
deactivate
