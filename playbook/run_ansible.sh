#!/bin/bash

if ! command -v ansible &> /dev/null; then
  echo "[!] Installing Ansible..."
  sudo pacman -Sy --noconfirm ansible
else
  echo "[*] Ansible already installed."
fi

#ansible-galaxy install -r requirements.yml

ansible-playbook -i inventory site.yml