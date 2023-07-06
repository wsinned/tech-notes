# NixOS Installation guide

For reference, official guide: https://nixos.org/manual/nixos/stable/index.html#ch-installation

Download the minimal installer image here (23.05 current stable): https://channels.nixos.org/nixos-23.05/latest-nixos-minimal-x86_64-linux.iso

Write the image to Usb via Etcher or similar.

## Initial Boot

Insert flash drive and power on. Press F12 (or equivalent) for boot menu and choose UEFI Flash Drive option.

Once at the command prompt type the following commands, ignoring the comments starting with #:
````
# passwordless sudo is available in the installer
$ sudo -i  

# set the preferred keyboard layout for your hardware
$ loadkeys uk
````

## Configure wifi

````
$ sudo systemctl start wpa_supplicant

$ wpa_cli
````
and then type the commands prefixed by the > prompt:

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
$ wipefs /dev/sda --all

$ parted /dev/sda

# Create the GPT partition table
(parted) mklabel gpt

# Add the root partition (reserves 512MB at beginning nad 8GB at end)
(parted) mkpart primary 512MB -8GB

# Add the swap partition (last 8GB)
(parted) mkpart primary linux-swap -8GB 100%

# Add the boot partition
(parted) mkpart ESP fat32 1MB 512MB
(parted) set 3 esp on

(parted) quit
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

## Getting our own config

Clone the config repo

````
$ nix-env -f '<nixpkgs>' -iA git

$ mkdir -p /mnt/tmp

$ git clone https://github.com/wsinned/tech-notes/ /mnt/tmp/tech-notes
````

Back up the generated config, then copy the config from the repo to the nixos folder and then run the installation:
````
$ cd /mnt/etc/nixos

$ mv configuration.nix configuration.nix.bak

$ cp /mnt/tmp/tech-notes/nixos-installation/configuration.nix .

$ cd /

$ nixos-install
````

## Set Up User & Install Home Manager

Set a root password when prompted. Then enter the newly installed chroot environment and set the password for main user. Finally assume the new user.

````
$ nixos-enter --root /mnt

$ passwd wsinned

$ su - wsinned

````
Ignore any zsh configuration prompts at this point. 

While still inside of the chroot environment, acting as the new user, install standalone home-manager. Base instructions taken from here: https://nix-community.github.io/home-manager/index.html#sec-install-standalone

Add the Home Manager channel and install

````
$ sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
$ sudo nix-channel --update

$ nix-shell '<home-manager>' -A install
````

Move the repo previously cloned from tmp into the user's home folder, link the configs from the repo and switch to it:

````
$ sudo mv /tmp/tech-notes ~/tech-notes

$ sudo chown -R wsinned ~/tech-notes

$ sudo rm /etc/nixos/configuration.nix

$ sudo ln ~/tech-notes/nixos-installation/configuration.nix /etc/nixos/configuration.nix

$ rm ~/.config/home-manager/home.nix

$ ln ~/tech-notes/nixos-installation/home.nix ~/.config/home-manager/home.nix

$ export NIXPKGS_ALLOW_UNFREE=1

$ home-manager switch
````

Clean up, exiting the su session, then the chroot, and then reboot.

````
$ exit

$ exit

$ reboot
````
