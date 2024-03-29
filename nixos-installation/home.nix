{ config, pkgs, lib, ... }: { # Home Manager needs a bit of information about you and the paths it should manage. 
  home.username = "wsinned";
  home.homeDirectory = "/home/wsinned";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bitwarden
    dropbox-cli
    firefox
    ffmpeg
    gzip
    htop
    meslo-lgs-nf
    neofetch
    p7zip
    qpdf
    tutanota-desktop
    tree
    ulauncher
    zsh-powerlevel10k
    
    # generic devtools
    direnv
    gh
    ltex-ls

    # gaming
    protontricks

    # python tools
    python311Full
    python311Packages.pip
    python311Packages.meson
    pipx



    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".config/nixpkgs/config.nix".text = ''
      { allowUnfree = true; }
    '';

    # create a nix.conf to enable experimental nix command
    # flakes can be enabled here too
    ".config/nix/nix.conf".text = ''
      experimental-features = nix-command flakes
    '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/wsinned/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # These are needed for desktop files and font registration
  targets.genericLinux.enable = true;
  programs.bash.enable = true;
  fonts.fontconfig.enable = true;

  imports = [
    ./apps/oh-my-zsh.nix
    ./apps/git.nix
    ./apps/gh.nix
    ./apps/kitty.nix
    ./apps/unfree.nix

    # use to get a more up to date vscode
    # ./apps/unstable.nix 
  ];

}

