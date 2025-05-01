#!/usr/bin/env python3

from archinstall import Installer
from archinstall.default_profiles.minimal import MinimalProfile
from archinstall.lib.disk.device_model import FilesystemType
from archinstall.lib.disk.encryption_menu import DiskEncryptionMenu
from archinstall.lib.disk.filesystem import FilesystemHandler
from archinstall.lib.interactions.disk_conf import select_disk_config
from pathlib import Path

from archinstall.lib.locale import LocaleConfiguration

from functions import *
from archinstall.lib.models import User
from archinstall.lib.profile import ProfileConfiguration, profile_handler


# -- Define Variables --
hostname = ask_input("Enter the hostname for the system", "Riced_Arch")
timezone = ask_input("Enter the timezone", "Europe/Zurich")
keyboard_layout = ask_input("Enter the keyboard layout", "us")
sys_lang = ask_input("Enter the system language bsp en_US", "en_US")
username = ask_input("Enter the username", "arch")
password = ask_input("Enter the password", "password")
root_password = ask_input("Enter the root password", "password")



fs_type = FilesystemType('ext4')

# Choose the disk for installation
disk_config = select_disk_config()
fs_handler = FilesystemHandler(disk_config)
fs_handler.perform_filesystem_operations()
mountpoint = Path('/mnt')

# Locale
locale = LocaleConfiguration(
    kb_layout=keyboard_layout,
    sys_lang=sys_lang,
    sys_enc='UTF-8'
)



with Installer(
        mountpoint,
        disk_config,
        kernels=['linux']
) as installation:
    installation.mount_ordered_layout()
    installation.minimal_installation(hostname=hostname, )
    installation.add_additional_packages(['vim', 'wget', 'git', 'base-devel', 'networkmanager', 'openssh', 'sudo', 'os-prober', 'ansible'])

    # Optionally, install a profile of choice.
    # In this case, we install a minimal profile that is empty
    profile_config = ProfileConfiguration(MinimalProfile())
    profile_handler.install_profile_config(installation, profile_config)

    user = User(username, password, True)
    installation.create_users(user)
    installation.run_command('git clone https://github.com/ydfdas1f546g1df/ricing_bootstrap.git /root/bootstrap')
