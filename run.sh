#!/bin/bash
set -e

# Install dependencies
pacman -Sy --noconfirm python python-pip git

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
