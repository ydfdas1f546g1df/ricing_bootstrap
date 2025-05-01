#!/bin/bash
set -e

# Install dependencies
echo "[*] Installing python-pip..."
pacman -Sy --noconfirm python-archinstall git

# Run the application
echo "[*] Running base installer..."
python base_install/main.py