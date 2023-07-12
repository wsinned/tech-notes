# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-68eac8bb-8b2f-46f0-a7f2-536c1a176cda".device = "/dev/disk/by-uuid/68eac8bb-8b2f-46f0-a7f2-536c1a176cda";
  boot.initrd.luks.devices."luks-68eac8bb-8b2f-46f0-a7f2-536c1a176cda".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "dw-nixos-dell"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # enable avahi dns
  services.avahi = {
    enable = true;
    nssmdns = true;
    ipv4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Budgie Desktop environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.budgie.enable = true;

  services.xserver.displayManager.lightdm.greeters.slick = {
    theme = { name = "Materia"; package = pkgs.materia-theme; };
    iconTheme = { name = "Papirus"; package = pkgs.papirus-icon-theme; };
    cursorTheme = { name = "Adwaita"; package = pkgs.gnome.adwaita-icon-theme; };
  };
  

  # Configure keymap in X11
  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable docker
  virtualisation.docker.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.wsinned = {
    isNormalUser = true;
    home = "/home/wsinned";
    shell = pkgs.zsh;
    description = "Dennis Woodruff";
    extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDa7tK7bQJUVrCRWsc/TVle2UgTcvZnpwY0lV468wxIuRsvIiHBUvJisd27yqTt8sTfhWUVYkOO64PDBdSKqBHNgob5KSjCx9Owg8lkj8bOPAoknWIN6aqC+iLLGgGDv2iidV60VpuvT+Dh49WIn8hvC7zMQaB3bJ3xIm37GmVAvcFN1DWVArp143NqtJUudnqXWT5QL7GOUXnGigx52sZrtlUtAYeR75WcbGysUeKxHAqAa7m7qg0xPm3u3iGDQQ5IrKNj/84+mvO7RCjRYn/63hi7hXw5YBiVJZRkMiML7XQ5EZ9NlSjipqy72Fkjm9STkWlcMQOB0ZlBdAGNkM2/bRzyqodKt/WPYdhq2qgusfEclzbizlZXZtfMqTu6MUiaB0s8FbLkroqrueyeQjhx9Nff6+9YmWnThwz5TJbrbFSqS8f+SdDOiDHIxmRVoWxHLt7CKGjC8vObAyPtIMd+F6zNYRFhA3xNMghAGztyvYgatydfEJre5S0xn5YFSys= dennisw@CA-MBP-773.local" ];
  };


  programs = {
    git.enable = true;
    zsh.enable = true;
    dconf.enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.wsinned = import ./home.nix;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    avahi
    duf
    git
    mc
    neovim
    python311Full
    python311Packages.pip
    pipx
    wget

    # override themes for budgie
    gnome.adwaita-icon-theme

  ];

  environment.localBinInPath = true;

  environment.budgie.excludePackages = [
    pkgs.mate.mate-terminal
    pkgs.vlc
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

