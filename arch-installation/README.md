# arch-installation

## Initial boot

Download the installation media and prepare boot media as described here: https://archlinux.org/download/
If you don't use a fresh installation image, there will be issues with out of date keys signing the packages. Follow the instructions in [Maintenance](#maintenance)

Boot from installation media into root account. Ensure that you use UEFI boot mode and not Legacy or BIOS boot mode. Hit F12 to see the boot menu on a Dell e6230.

Select keymap

````loadkeys uk````

Test keyboard

Double check you are in EFI mode

````ls /sys/firmware/efi/efivars````

If the efi/efivars folder don't exist, you have booted in legacy BIOS mode. Shutdown and use F12 again to choose a UEFI boot mode.


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

### Set up networking

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
useradd -m -G wheel,sudoers wsinned
passwd wsinned
````

## Additional

### Setup microcode

This applies updates CPU updates

````
pacman -S intel-ucode
````

## Bootloader

Basics

````
pacman -S grub efibootmgr
````

EFI Folder

````
mkdir /boot/efi
mount /dev/sda1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg
````

## Reboot

Exit from chroot shell and unmount installation drive

````
exit
umount -R /mnt
reboot
````

Once rebooted, login as standard user to complete.

## Reconnect to network

````
nmcli device wifi list
sudo nmcli device wifi connect XX:XX:XX:XX:XX password wifi-password
````

## Get tools for AUR

````
pacman -Sy git

cd /opt
git clone https://github.com/Jguer/yay
cd yay
makepkg -si

````

## XOrg + Budgie

````
yay -S xorg-server
yay -S xf86-video-intel
yay -S budgie-desktop budgie-desktop-view budgie-screensaver budgie-control-center lightdm lightdm-slick-greeter lightdm-settings
````

## Extras

As currently installed there is nothing but the bare minimum, not even a terminal or browser

````
yay -Sy kitty google-chrome zsh asdf-vm neovim powertop-auto-tune nerd-fonts-meslo nerdfetch ulauncher ffmpeg signal-desktop
````

Reboot and you should see the greeter to login to Budgie Desktop

## Look and Feel

Get things looking the way I like them

````
yay -Sy papirus-icon-theme materia-theme
````
Now choose these in Budgie Desktop Manager.

Next it's all languages and runtimes and dev tools.


## Tools

### Shell

We already have zsh from earlier. Using a direct install of oh-my-zsh as the AUR package seems to have issues. Nerd font was also installed earlier. Install Powerlevel10K and Auto-suggestions. Enabling auto suggestions and ASDF.

Open kitty settings ctrl-shift-F2

````
> font_family MesloLGS NF
> font_size 15.0

> tab_bar_edge top

````

Configure zsh

````

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

nvim .zshrc

> ZSH_THEME="powerlevel10k/powerlevel10k"
> plugins=(git zsh-autosuggestions asdf aliases)
````

Restart the shell and run through the configuration of Powerlevel10k theme.


### Languages

Install prerequisites for Python

````
yay -Sy --needed openssl zlib xz tk
````

Install languages and set globally

````
asdf plugin add nodejs
asdf plugin add golang
asdf plugin add python

asdf install nodejs latest:16
asdf install golang lastest
asdf install python latest

asdf global nodejs latest:16
asdf global golang latest
asdf global python latest
````


Credit: https://www.freecodecamp.org/news/how-to-install-arch-linux/

### Maintenance

I found out the hard way that if you don't update frequently (away for a 2 weeks holiday) you can end up in a sitation where the signing keys are out of date. The simplest solution is to to this

````
pacman -Sy archlinux-keyring && pacman -Su
````

Found in the docs here: https://wiki.archlinux.org/title/Pacman/Package_signing#Upgrade_system_regularly

