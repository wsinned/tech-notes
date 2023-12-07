{ config, pkgs, ... }:

{
  imports = [
    ./apps/oh-my-zsh.nix
    ./apps/git.nix
    ./apps/gh.nix
    # ./apps/kitty.nix # Kitty has openGl issues when not used on NixOs. Use native install instead
    
    # This can be commented out on initial installation 
    # to simplify the command line
    # 
    ./apps/unfree.nix

  ];

  home.username = "wsinned";
  home.homeDirectory = "/home/wsinned";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [

    ## Essentials to install for a basic setup

    ffmpeg
    gzip
    neofetch
    neovim
    p7zip
    tree
    direnv


    ## Dependencies for OhMyZsh
    meslo-lgs-nf
    zsh-powerlevel10k


    ## Vault: things to remember to install manually

    # asdf-vm  # has issues when not used on NixOs. Use native install instead
    # bitwarden-cli # do I need this?
    # meld # has issues on Ubuntu from Nix
    # ulauncher # not needed on Ububtu
    # powertop
    # tlp
    # mc  # has issues on Ubuntu from Nix

    # tutanota-desktop  # Never works well, but does work    
  ];

  programs.home-manager.enable = true;

  # These are needed for desktop files and font registration
  targets.genericLinux.enable = true;
  programs.bash.enable = true;
  fonts.fontconfig.enable = true;
}


