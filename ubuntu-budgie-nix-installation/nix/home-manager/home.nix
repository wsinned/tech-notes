{ config, pkgs, ... }:

{
  imports = [
    ./apps/oh-my-zsh.nix
    ./apps/git.nix
    ./apps/gh.nix
    ./apps/kitty.nix
  ];

  home.username = "wsinned";
  home.homeDirectory = "/home/wsinned";
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    asdf-vm
    authy
    baobab
    bitwarden
    bitwarden-cli
    discord
    # firefox
    ffmpeg
    # google-chrome
    gparted
    gzip
    htop
    jre_minimal
    meslo-lgs-nf
    neofetch
    neovim
    p7zip
    #powertop
    shutter
    signal-desktop 
    slack
    #tlp
    tutanota-desktop
    tree
    ulauncher
    zsh-powerlevel10k
    
    # generic devtools
    direnv
    gh
    #kitty
    meld
    postman
    vscode
  ];
  programs.home-manager.enable = true;
}


