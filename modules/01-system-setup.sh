#!/usr/bin/env bash
# 01-system-setup.sh

set -e
source $(dirname "$0")/../includes/utils.sh


echo "[*] Running system setup..."

echo "[*] Installing required packages..."
pacman -Sy --noconfirm --needed parted xfsprogs efibootmgr grub



echo "[*] Starting basic system setup on $DISK..."

# --- Partition & Format ---
echo "[*] Partitioning and formatting disk..."

create_gpt "$DISK"

# Create partitions
homedisk=$(partition_disk "$DISK" "$DISK_SIZE_HOME" "primary" "xfs")
vardisk=$(partition_disk "$DISK" "$DISK_SIZE_VAR" "primary" "xfs")
swapdisk=$(partition_disk "$DISK" "$DISK_SIZE_SWAP" "primary" "swap")
bootdisk=$(partition_disk "$DISK" "1GiB" "primary" "ext4")
efidisk=$(partition_disk "$DISK" "1GiB" "primary" "vfat")
rootdisk=$(partition_disk "$DISK" "u" "primary" "xfs")

# Format paritions
format_disk "$rootdisk" "xfs" "/"
format_disk "$homedisk" "xfs" "/home"
format_disk "$vardisk" "xfs" "/var"
format_disk "$bootdisk" "ext4" "/boot"
format_disk "$efidisk" "vfat" "/boot/efi"
format_swap "$swapdisk" "swap"

# Mount Root Partition
mount "$rootdisk" /mnt

# Create Mounting Directories
mkdir -p /mnt/home
mkdir -p /mnt/var
mkdir -p /mnt/boot
mkdir -p /mnt/boot/efi

# Mount Partitions
mount "$homedisk" /mnt/home
mount "$vardisk" /mnt/var
mount "$bootdisk" /mnt/boot
mount "$efidisk" /mnt/boot/efi


# --- Base System Installation ---
echo "[*] Installing base system..."
pacstrap /mnt base linux linux-firmware vim sudo grub efibootmgr xfsprogs parted base-devel 

# --- Generate fstab ---
echo "[*] Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab
echo "[*] fstab generated:"
cat /mnt/etc/fstab

# --- Copy Configuration Files ---
mkdir -p /mnt/root/bootstrap
cp -r ./ /mnt/root/bootstrap



# --- Chroot into the new system ---
echo "[*] Chrooting into the new system..."
arch-chroot /mnt bash /root/bootstrap/modules/x02-user-setup.sh
echo "[*] System setup complete!"