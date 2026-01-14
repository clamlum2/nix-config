{ config, pkgs, nixpkgs-stable, ... }:

let
  stable = import nixpkgs-stable {
    system = pkgs.system or "x86_64-linux";
    config.allowUnfree = true;
  };
in

{
  nixpkgs ={
    config.allowUnfree = true;
    overlays = [
      (import ./overlays/vesktop.nix)
    ];
  };


  environment.systemPackages = [
    pkgs.git
    pkgs.vscode
    pkgs.ghostty
    pkgs.easyeffects
    pkgs.spotify
    pkgs.playerctl
    pkgs.wl-clipboard
    pkgs.p7zip

    pkgs.jetbrains.pycharm
    pkgs.python3

    pkgs.vesktop-with-wayland

    (import ./apps/helium.nix { inherit pkgs; })
  ];
}
