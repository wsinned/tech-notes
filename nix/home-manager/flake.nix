{
  description = "My Ubuntu Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    # system = "aarch64-linux"; If you are running on ARM powered computer
    pkgs = import nixpkgs { 
      system = "x86_64-linux"; 
      config = { 
        allowUnfree = true; 
        }; 
      };
  in {
      homeConfigurations."wsinned" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home-manager/home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
  };
}


