
sudo nix-channel --update
sudo nixos-rebuild build

nvd diff /run/current-system ./result

