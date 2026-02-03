{ config, pkgs, nixpkgs-stable, ... }:

let
  stable = import nixpkgs-stable {
    system = pkgs.system or "x86_64-linux";
    config.allowUnfree = true;
  };
in

{
  programs.obs-studio = {
    enable = true;
    package = stable.obs-studio.override {
      cudaSupport = true;
    };
  };
}