# arch-installation

## Initial boot

Boot from installation media into root account

Select keymap

````loadkeys uk````

Test keyboard

Double check you are in EFI mode

````ls /sys/firmware/efi/efivars````

## Connect to Wifi

````
iwctl
> device list
> station wlan0 scan
> station wlan0 get-networks
> station wlan0 connect VodafoneConnect56623681
> password:########
> exit
ping -c5 google.com
````

## Set clock for ntp

````timedatectl set-ntp true````

## Partition the installation disk
### Partition used
````
cfdisk /dev/sda

> /dev/sda1 500M EFI
> /dev/sda2 8G Swap
> /dev/sda3 Rest Linux
````

### Create the file systems

````
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3
````

### Use the file systems
````
mount /dev/sda3 /mnt
swapon /dev/sda2
````

## Setup package and install

### Set up mirrors
````
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
reflector --download-timeout 60 --country 'United Kingdom' --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
````

### Update mirrors

````
pacman -Sy
````

### Bootstrap the system

````
pacstrap /mnt base base-devel linux linux-firmware sudo nano vim ntfs-3g networkmanager
````

## Post installation

### Generate fstab

Uses the current mounted file systems as a template

````
genfstab -U /mnt >> /mnt/etc/fstab
````

### Chroot to you new installation

No reboot required

````
arch-chroot /mnt
````

### Set the timezone

Zones are all kept in the same zoneinfo folder structure

````
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
````

### Edit and gen locales

````
vim /etc/locale.gen
# uncomment needed lines, en_GB.UTF-8, en_US.UTF-8

locale-gen

vim /etc/locale.conf
> LANG=en_GB.UTF-8

vim /etc/vconsole.conf
> KEYMAP=uk
````

### Set up netowrking

````
vim /etc/hostname
> dw-arch-dell

vim /etc/hosts
> 127.0.0.1        localhost
> ::1              localhost
> 127.0.1.1        dw-arch-dell

systemctl enable NetworkManager
````

## Setup Users

### Set root password

````passwd````

### Create non-root user

````
useradd -m -G wheel wsinned
passwd wsinned
````

## Additional

### Setup microcode

This applies updates CPU updates

````
pacman -S intel-ucode
````
