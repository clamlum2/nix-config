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

  nixpkgs.overlays = [
    (import apps/overlays/idea.nix)
  ];

  environment.systemPackages = [
    #
    pkgs.git
    pkgs.vscode
    pkgs.python3
    pkgs.python3Packages.pyqt6
    pkgs.gradle_9
    pkgs.jdk25
    pkgs.zed-editor

    pkgs.idea

    # media
    pkgs.easyeffects
    pkgs.spotify
    pkgs.playerctl
    pkgs.mpv
    pkgs.ffmpeg
    stable.handbrake
    stable.feishin

    # tools
    pkgs.wl-clipboard
    pkgs.p7zip
    pkgs.localsend
    pkgs.nautilus

    # other
    # pkgs.davinci-resolve

    (pkgs.callPackage ./apps/helium.nix {})
  ];
}
