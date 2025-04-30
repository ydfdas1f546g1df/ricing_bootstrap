#!/usr/bin/env bash
# 00-variables.sh

source $(dirname "$0")/../includes/questions.sh

# Variables
# This script contains the variables used in the other scripts

export HOSTNAME=$(ask_input "Enter the hostname" "RICED PC")
export USERNAME=$(ask_input "Enter the username" "arch")
export PASSWORD=$(ask_input "Enter the password" "password")
export TIMEZONE=$(ask_input "Enter the timezone" "Europe/Zurich")
export LOCALE=$(ask_input "Enter the locale" "en_US.UTF-8")
export KEYMAP=$(ask_input "Enter the keymap" "us")
export ROOT_PASSWORD=$(ask_input "Enter the root password" "rootpassword")
export DISK=$(ask_input "Enter the disk to install OS on\n $(lsblk)\n" "/dev/sda")
export DISK_SIZE_HOME=$(ask_input "Enter the size of the home partition (e.g. 20G, 100G, 1T, etc.)" "20G")
export DISK_SIZE_SWAP=$(ask_input "Enter the size of the swap partition (e.g. 20G, 100G, 1T, etc.)" "8G")
export DISK_SIZE_VAR=$(ask_input "Enter the size of the var partition (e.g. 20G, 100G, 1T, etc.)" "20G")
export software_addon=$(ask_input "Enter additional Software to install (e.g. 'git vim', 'firefox')" "")
