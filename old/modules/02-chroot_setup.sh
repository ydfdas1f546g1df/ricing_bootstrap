#!/usr/bin/env bash
# 02-user-setup.sh

# Take arguments
USERNAME=$1
PASSWORD=$2
ROOT_PASSWORD=$3
TIMEZONE=$4
LOCALE=$5
KEYMAP=$6
HOSTNAME=$7


# --- Set Timezone ---

echo "[*] Setting timezone..."
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc
echo "[*] Timezone set to $TIMEZONE"

# --- Set Locale ---
echo "[*] Setting locale..."
echo "LANG=$LOCALE" > /etc/locale.conf
echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "[*] Locale set to $LOCALE"

# --- Set Hostname ---
echo "[*] Setting hostname..."
echo "$HOSTNAME" > /etc/hostname
echo "[*] Hostname set to $HOSTNAME"

# --- Set Root Password ---
echo "[*] Setting root password..."
echo -e "$ROOT_PASSWORD\n$ROOT_PASSWORD" | passwd
echo "[*] Root password set"

# --- Create User ---
echo "[*] Creating user..."
useradd -m -s /bin/bash -G wheel "$USERNAME"
echo -e "$PASSWORD\n$PASSWORD" | passwd "$USERNAME"
echo "[*] User $USERNAME created"

# --- Configure Sudo ---
echo "[*] Configuring sudo..."
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo "[*] Sudo configured"


# --- Install Bootloader ---
echo "[*] Installing systemd-boot..."
bootctl install || error "Failed to install systemd-boot"

echo "[*] Creating loader.conf..."
cat > /boot/loader/loader.conf <<EOF
default arch
timeout 4
editor no
EOF

echo "[*] Creating Arch boot entry..."
cat > /boot/loader/entries/arch.conf <<EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=$(findmnt / -o SOURCE -n) rw
EOF


# Update System
echo "[*] Updating system..."
pacman -Syu --noconfirm
echo "[*] System updated"

# Install Network manager and nmtui
echo "[*] Installing NetworkManager..."
pacman -Sy --noconfirm networkmanager network-manager-applet
echo "[*] Enabling NetworkManager..."
systemctl enable NetworkManager
echo "[*] Starting NetworkManager..."
systemctl start NetworkManager
echo "[*] NetworkManager started"

echo "[*] Create Oneshot script..."
cat > /etc/systemd/system/rice-bootstrap.service <<EOF
[Unit]
Description=Post-install Arch Rice Setup
After=multi-user.target network-online.target

[Service]
StandardInput=tty
StandardOutput=journal+console
StandardError=tty
TTYPath=/dev/tty1
TTYReset=yes
TTYVHangup=yes
TTYVTDisallocate=yes
Type=oneshot
ExecStart=/root/bootstrap/rice-bootstrap-reboot.sh
ExecStartPost=/usr/bin/systemctl disable rice-bootstrap.service
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

echo "[*] Enabling oneshot service..."
systemctl enable rice-bootstrap.service


# reboot
echo "[*] Rebooting system..."
reboot