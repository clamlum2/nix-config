{
  pkgs,
  nixpkgs-stable,
  device,
  inputs,
  ...
}:

let
  stable = import nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

  globalPkgs = [
    pkgs.git
    pkgs.python3
    pkgs.rustc
    pkgs.rustPlatform.rustLibSrc
    pkgs.cargo

    pkgs.mpv
    pkgs.ffmpeg

    pkgs.localsend
    pkgs.obsidian
  ];

  linuxPkgs = [
    pkgs.easyeffects
    pkgs.playerctl
    stable.handbrake

    pkgs.wl-clipboard
    pkgs.p7zip
    pkgs.nautilus

    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default

    (pkgs.discord.override {
      withVencord = true;
      withOpenASAR = true;
    })
  ];

  nixosPkgs = [
    pkgs.gradle_9
    pkgs.jdk25
    pkgs.idea
  ];

  macbookPkgs = [
    pkgs.vesktop
    pkgs.gradle_9
    pkgs.jdk25
    pkgs.jetbrains.idea
    pkgs.prismlauncher
    pkgs.libreoffice-bin
    stable.yt-dlp
  ];
in

{
  environment.systemPackages =
    [ ]
    ++ globalPkgs
    ++ (
      if device == "nixos" then
        nixosPkgs ++ linuxPkgs
      else if device == "macbook" then
        macbookPkgs
      else
        linuxPkgs
    );

  nixpkgs = {
    config.allowUnfree = true;
  };

  nixpkgs.overlays =
    if device != "macbook" then
      [
        (import apps/overlays/idea.nix)
        (import apps/overlays/discord.nix)
      ]
    else
      [ ];
}
