#!/usr/bin/env bash
# Utility functions for the script
# include/utils.sh

# Error Output
error() {
    echo "ERROR: $1" >&2
    exit 1
}

# Confirmation prompt
confirm() {
    read -rp "$1 [y/N]: " yn
    case "$yn" in
        [Yy]*) return 0 ;;
        *) return 1 ;;
    esac
}

# Ask for user input with default value
ask_input() {
    local prompt="$1"
    local default="$2"
    printf "%b" "$prompt [$default]: "
    read -r input
    if [ -z "$input" ]; then
        input="$default"
    fi
    echo -e "$input"
}

# Disk formating function
format_disk() {
    local disk="$1"
    local fs_type="$2"
    local mount_point="$3"

    echo "[*] Formatting $disk with $fs_type..."
    mkfs."$fs_type" "$disk" || error "Failed to format $disk with $fs_type"
    echo "[*] Mounting $disk to $mount_point..."
    mount "$disk" "$mount_point" || error "Failed to mount $disk to $mount_point"
}

partition_disk() {
    local disk="$1"
    local size="$2"       # e.g. 1GiB, 500MiB, or "u"
    local part_type="$3"  # e.g. primary
    local fs_type="$4"    # e.g. ext4

    if [[ -z "$disk" || -z "$size" || -z "$part_type" || -z "$fs_type" ]]; then
        echo "Usage: partition_disk <disk> <size|'u'> <part_type> <fs_type>"
        return 1
    fi

    # Determine start and end of free space
    local start end
    read -r start end <<< $(parted -ms "$disk" unit MiB print free | awk -F: '
        /free/ {
            gsub("MiB", "", $2); gsub("MiB", "", $3);
            if ($2 >= 1) s=$2; e=$3
        }
        END { print s, e }')

    if [[ -z "$start" || -z "$end" ]]; then
        echo "[!] Could not determine free space on $disk"
        return 1
    fi

    # Calculate end based on size or use entire space
    if [[ "$size" == "u" ]]; then
        echo "[*] Using full free space: ${start}MiB -> ${end}MiB"
    else
        # Convert GiB/MiB to MiB
        if [[ "$size" =~ ^([0-9]+)([gG][iI][bB])$ ]]; then
            size_mib=$(( ${BASH_REMATCH[1]} * 1024 ))
        elif [[ "$size" =~ ^([0-9]+)([mM][iI][bB])$ ]]; then
            size_mib=${BASH_REMATCH[1]}
        else
            echo "[!] Invalid size format: $size (use e.g. 1GiB or 500MiB)"
            return 1
        fi

        end=$(echo "$start + $size_mib" | bc)
        echo "[*] Creating partition: ${start}MiB -> ${end}MiB"
    fi

    # Create partition
    parted -s "$disk" mkpart "$part_type" "$fs_type" "${start}MiB" "${end}MiB" || {
        echo "[!] Failed to create partition"
        return 1
    }

    partprobe "$disk"
    sleep 1

    # Find and return the latest partition
    local part
    part=$(lsblk -ln -o NAME "$disk" | grep -oE "${disk##*/}[0-9]+" | sort -n | tail -n1)
    if [[ -z "$part" ]]; then
        error "Partition creation failed on $disk"
    fi
    echo "/dev/$part"

    
}

# Format Swap function
format_swap() {
    local swapdisk="$1"

    echo "[*] Formatting $swapdisk as swap..."
    mkswap "$swapdisk" || error "Failed to format $swapdisk as swap"
    echo "[*] Enabling swap on $swapdisk..."
    swapon "$swapdisk" || error "Failed to enable swap on $swapdisk"
}

# Disk GPT function
create_gpt() {
    local disk="$1"

    echo "[*] Creating GPT partition table on $disk..."
    parted "$disk" mklabel gpt || error "Failed to create GPT partition table on $disk"
}