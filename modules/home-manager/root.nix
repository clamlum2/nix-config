{ config, pkgs, lib, nixpkgs-stable, ... }:

let
  unstable = import nixpkgs-stable {
    system = pkgs.system or "x86_64-linux";
    config.allowUnfree = true;
  };
in

{
  home.username = "root";
  home.homeDirectory = "/root";
  home.stateVersion = "25.11";
}
