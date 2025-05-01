#!/bin/bash
set -e

# Install dependencies
echo "[*] Installing python-pip..."
pacman -Sy --noconfirm python-pip git

echo "[*] Installing python deps..."
pip install -r requirements.txt

# Run the application
echo "[*] Running base installer..."
python base_install/main.py