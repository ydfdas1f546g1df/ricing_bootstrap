#!/usr/bin/env bash
# master.sh

# This script is the main entry point for the Arch Linux installation process.
# It will call the other scripts in the correct order and handle any errors.

source $(dirname "$0")/includes/utils.sh

# --- Variables ---
export SCRIPT_DIR=$(dirname "$0")
export LOG_FILE="$SCRIPT_DIR/install.log"

for file in $(ls | sort -n); do
  if [[ -x "$file" && "$file" == *.sh ]]; then
    echo "Running $file"
    ./"$file"
  fi
done

# Reboot if not interrupted
confirm "Reboot the system?" && reboot