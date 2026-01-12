{ config, pkgs, lib, nixpkgs-stable, ... }:

let
  unstable = import nixpkgs-stable {
    system = pkgs.system or "x86_64-linux";
    config.allowUnfree = true;
  };
in

{
  home.username = "clamt";
  home.homeDirectory = "/home/clamt";
  home.stateVersion = "25.11";
}
