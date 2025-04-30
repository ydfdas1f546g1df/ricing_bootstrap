#!/usr/bin/env bash
# rice-bootstrap-reboot.sh

echo "[*] Disabling self-triggering post-install service..."
systemctl disable rice-bootstrap.service
