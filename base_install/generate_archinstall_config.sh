#!/usr/bin/env bash

# --- Ask user for required inputs ---
read -rp "Enter the hostname [Riced_Arch]: " hostname
hostname=${hostname:-Riced_Arch}

read -rp "Enter the timezone [Europe/Zurich]: " timezone
timezone=${timezone:-Europe/Zurich}

read -rp "Enter the keyboard layout [us]: " keyboard_layout
keyboard_layout=${keyboard_layout:-us}

read -rp "Enter the system language (e.g. en_US) [en_US]: " sys_lang
sys_lang=${sys_lang:-en_US}

read -rp "Enter the username [arch]: " username
username=${username:-arch}

read -rsp "Enter the password: " password
echo
read -rsp "Enter the root password: " root_password
echo

# --- Disk config via Archinstall TUI ---
echo "Launching Archinstall disk config tool..."
archinstall guided --disk-layout --silent > /tmp/disk_config.json || {
  echo "Disk selection failed."
  exit 1
}

# Sanity check
if ! grep -q "/dev" /tmp/disk_config.json; then
  echo "Disk config is empty or invalid."
  cat /tmp/disk_config.json
  exit 1
fi

# --- Generate Final Config ---
jq -n \
  --arg hostname "$hostname" \
  --arg timezone "$timezone" \
  --arg kb_layout "$keyboard_layout" \
  --arg sys_lang "$sys_lang" \
  --arg username "$username" \
  --arg password "$password" \
  --arg root_password "$root_password" \
  --slurpfile disk_cfg /tmp/disk_config.json \
  '{
    version: "1.0",
    disk_encryption: false,
    bootloader: "systemd-bootctl",
    kernels: ["linux"],
    harddrives: $disk_cfg[0].harddrives,
    filesystem: $disk_cfg[0].filesystem,
    hostname: $hostname,
    locale: {
      language: $sys_lang,
      encoding: "UTF-8",
      keyboard_layout: $kb_layout,
      timezone: $timezone
    },
    users: [{
      name: $username,
      password: $password,
      is_sudoer: true
    }],
    "root-password": $root_password,
    network_configuration: {
      method: "NetworkManager"
    },
    additional_packages: [
      "vim", "wget", "git", "base-devel",
      "networkmanager", "openssh", "sudo",
      "os-prober", "ansible"
    ],
    profile: "minimal"
  }' > /tmp/archinstall_config.json

echo "Config written to /tmp/archinstall_config.json"
