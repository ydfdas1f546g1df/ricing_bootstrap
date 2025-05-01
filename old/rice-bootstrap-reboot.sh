#!/usr/bin/env bash
# rice-bootstrap-reboot.sh

set -euo pipefail



echo -e "\n\n\n\nWelcome to Rice Bootstrap v1.0\n\n\n\n"


log() {
  echo "[*] $1"
}

error() {
  echo "[!] ERROR: $1"
  exit 1
}

POST_INSTALL_SCRIPT="/root/bootstrap/modules/03-setup_after_reboot.sh"

log "Starting post-install process..."

if [[ -x "$POST_INSTALL_SCRIPT" ]]; then
  "$POST_INSTALL_SCRIPT"
else
  error "Post-install script '$POST_INSTALL_SCRIPT' not found or not executable"
fi

log "Post-install process completed."