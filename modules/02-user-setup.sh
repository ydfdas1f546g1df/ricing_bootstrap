#!/usr/bin/env bash
# 02-user-setup.sh

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
echo "[*] Installing bootloader..."