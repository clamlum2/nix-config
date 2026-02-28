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
  };


  environment.systemPackages = [
    #
    pkgs.git
    pkgs.vscode
    pkgs.python3
    pkgs.python3Packages.pyqt6
    # stable.jetbrains.idea

    # media
    pkgs.easyeffects
    pkgs.spotify
    pkgs.playerctl
    pkgs.mpv
    pkgs.ffmpeg
    stable.handbrake
    pkgs.feishin

    # tools
    pkgs.wl-clipboard
    pkgs.p7zip
    pkgs.localsend
    pkgs.nautilus

    # other
    pkgs.vesktop

    (import ./apps/helium.nix { inherit pkgs; })
  ];
}
