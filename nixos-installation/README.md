# NixOS Installation guide

For reference, official guide: https://nixos.org/manual/nixos/stable/index.html#ch-installation

Download the minimal installer image here (23.05 current stable): https://channels.nixos.org/nixos-23.05/latest-nixos-minimal-x86_64-linux.iso

Write the image to Usb via Etcher or similar.

## Initial Boot

Insert flash drive and power on. Press F12 (or equivalent) for boot menu and choose UEFI Usb option.

Once at the command prompt type the following commands, ignoring the comments starting with #:
````
# passwordless sudo is available in the installer
$ sudo -i  

# set the preferred keyboard layout for your hardware
$ loadkeys uk
````

## Configure wifi

Run wpa_cli and then type the commands prefixed by the > prompt:

````
> add_network
0
> set_network 0 ssid "myssid"
OK
> set_network 0 psk "mypassword"
OK
> set_network 0 key_mgmt WPA-PSK
OK
> enable_network 0
OK
````
Once you see a `CTRL-EVENT-CONNECTED` message you can quit.

## Partition the primary disk

This is done manually and is destructive. Don't use this if you don't mean it.

````
# Create the GPT partition table
$ parted /dev/sda -- mklabel gpt

# Add the root partition (reserves 512MB at beginning nad 8GB at end)
$ parted /dev/sda -- mkpart primary 512MB -8GB

# Add the swap partition (last 8GB)
$ parted /dev/sda -- mkpart primary linux-swap -8GB 100%

# Add the boot partition
$ parted /dev/sda -- mkpart ESP fat32 1MB 512MB
$ parted /dev/sda -- set 3 esp on
````

## Formatting

````
# Root partition
$ mkfs.ext4 -L nixos /dev/sda1

# Swap partition
$ mkswap -L swap /dev/sda2

# Boot partition
$ mkfs.fat -F 32 -n boot /dev/sda3
````

## Installing

````
# Mount the target root file system by label assigned earlier
$ mount /dev/disk/by-label/nixos /mnt

# Mount the Boot file system by label assigned earlier
$ mkdir -p /mnt/boot
$ mount /dev/disk/by-label/boot /mnt/boot

# Enable swap
$ swapon /dev/sda2
````

## Generate the initial config

Tell the generator where to find root file system.

````
$ nixos-generate-config --root /mnt
````

This will have generated a very basic configuration at /etc/nixos/configuration.nix. We will be downloading and overwriting this with our own preconfigured files.

## TODO: Getting our own config
