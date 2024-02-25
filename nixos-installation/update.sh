duf /

sudo nix-channel --update
sudo nix-collect-garbage --delete-older-than 21d
sudo nixos-rebuild boot --upgrade
flatpak update -y

duf /