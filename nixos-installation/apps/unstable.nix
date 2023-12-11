{ pkgs, config, ... }:

let

  pkgsUnstable = import <nixpkgs-unstable> {};

in

{
  home.packages = [
    pkgsUnstable.vscode
  ];

  # …
}