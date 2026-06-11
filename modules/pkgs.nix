{ pkgs, nixpkgs-stable, device, ... }:

let
  stable = import nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in

{
  nixpkgs = {
    config.allowUnfree = true;
  };

  nixpkgs.overlays = [
    (import apps/overlays/idea.nix)
    (import apps/overlays/discord.nix)
  ];

  environment.systemPackages = [
    #
    pkgs.git
    pkgs.python3
    pkgs.python3Packages.pyqt6

    (pkgs.discord.override {
      withVencord = true;
      withOpenASAR = true;
    })

    # media
    pkgs.easyeffects
    pkgs.spotify
    pkgs.playerctl
    pkgs.mpv
    pkgs.ffmpeg
    stable.handbrake

    # tools
    pkgs.wl-clipboard
    pkgs.p7zip
    pkgs.localsend
    pkgs.nautilus

    (pkgs.callPackage ./apps/helium.nix { })
  ] ++ (
    if device == "nixos" then [
      pkgs.gradle_9
      pkgs.jdk25
      pkgs.idea
    ] else []
  );
}
