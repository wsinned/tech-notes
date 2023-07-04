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
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    asdf-vm
    authy
    direnv
    discord
    # etcher # removed as flagged insecure due to electron 12.2.3 being EOL. Investigate further
    ffmpeg
    google-chrome
    gzip
    htop
    insync
    jre_minimal
    meld
    p7zip
    postman
    powertop
    shutter
    signal-desktop 
    slack
    kitty
    neofetch
    tlp
    tutanota-desktop
    vscode

    meslo-lgs-nf
    tree
    ulauncher
    zsh-powerlevel10k
    

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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker-compose" "docker" ];
    };
    initExtraBeforeCompInit = ''
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
    ];
    initExtra = ''
      bindkey '^f' autosuggest-accept
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.emacs = {
    enable = true;
    extraConfig = ''
      (load-theme 'material t)
      (global-linum-mode t)
      (set-frame-font "MesloLGS NF 15" nil t)
      (setq-default cursor-type 'bar)

      (defun my-write-mode ()
        (interactive)
        (writeroom-mode t)
        (visual-line-mode t)
        (auto-save-visited-mode t))
      
      (global-set-key (kbd "<f5>") 'my-write-mode)
    '';
    extraPackages = epkgs: with epkgs; [
      markdown-mode
      material-theme
      writeroom-mode
      better-defaults
    ];
  };

  programs.git = {
    userName = "Dennis Woodruff";
    userEmail = "denniswoodruffuk@gmail.com";
    extraConfig = {
      init = { defaultBranch = "main"; };
      push = { default = "current"; };
      pull = { rebase = "true"; };
      rebase = { autoStash = "true"; };
    };
  };
}