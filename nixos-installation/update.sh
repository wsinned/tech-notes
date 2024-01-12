duf /

sudo nix-collect-garbage --delete-older-than 21d
sudo nixos-rebuild boot --upgrade
flatpak update -y

nix-channel --update
home-manager switch

duf /