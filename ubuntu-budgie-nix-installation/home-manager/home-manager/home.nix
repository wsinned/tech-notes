{ config, pkgs, ... }:

{
  imports = [
    ./apps/oh-my-zsh.nix
    ./apps/git.nix
    ./apps/gh.nix
  ];

  home.username = "wsinned";
  home.homeDirectory = "/home/wsinned";
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    asdf-vm
    authy
    # baobab
    # bitwarden-cli
    discord
    ffmpeg
    # google-chrome
    gzip
    jre_minimal
    meslo-lgs-nf
    neofetch
    neovim
    p7zip
    # powertop
    # tlp
    signal-desktop 
    slack

    tutanota-desktop
    tree
    ulauncher
    zsh-powerlevel10k
    
    # generic devtools
    direnv
    meld
    postman
    vscode
  ];
  programs.home-manager.enable = true;
}


