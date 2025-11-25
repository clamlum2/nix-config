{ config, pkgs, lib, nixpkgs-unstable, ... }:

let
  unstable = import nixpkgs-unstable {
    system = pkgs.system or "aarch64-linux";
    config.allowUnfree = true;
  };
in

{

  home.username = "clamt";
  home.homeDirectory = "/home/clamt";
  home.stateVersion = "25.05";

  imports = [
    ./../shell/zsh.nix
    ./../desktop/fonts.nix
  ];
}
