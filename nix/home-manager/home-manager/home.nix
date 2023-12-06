{ config, pkgs, ... }:

{
  imports = [
    ./apps/oh-my-zsh.nix
    ./apps/git.nix
    ./apps/gh.nix
    # ./apps/kitty.nix
    
    # This can be commented out on initial installation 
    # to simplify the command line
    # 
    ./apps/unfree.nix

  ];

  home.username = "wsinned";
  home.homeDirectory = "/home/wsinned";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    #asdf-vm
    # bitwarden-cli
    ffmpeg
    # google-chrome
    gzip
    mc
    meslo-lgs-nf
    neofetch
    neovim
    p7zip
    # powertop
    # tlp
    signal-desktop 

    tutanota-desktop
    tree
    # ulauncher
    zsh-powerlevel10k
    
    # generic devtools
    direnv
    meld
    
  ];
  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;
  programs.bash.enable = true;
  fonts.fontconfig.enable = true;
}


