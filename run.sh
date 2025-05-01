#!/bin/bash
set -e

# Check if enough free ram is available
if [ "$(free -m | awk '/^Mem:/{print $4}')" -lt 2048 ]; then
    echo "Not enough free RAM available. At least 2GB is required."
    exit 1
fi

# Make root directory bigger
mkdir /tmp/newroot
mount -t tmpfs -o size=1G tmpfs /tmp/newroot
rsync -aXS / /tmp/newroot
mount --bind /tmp/newroot /


# Install dependencies
pacman -Sy --noconfirm python python-pip git
pacman -Sy --noconfirm pkgconf gcc make

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
