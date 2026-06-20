{
  pkgs,
  nixpkgs-stable,
  device,
  ...
}:

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

  nixpkgs.overlays =
    if device != "macbook" then
      [
        (import apps/overlays/idea.nix)
        (import apps/overlays/discord.nix)
      ]
    else
      [ ];

  environment.systemPackages = [
    #
    pkgs.git
    pkgs.python3
    pkgs.cargo

    # media
    pkgs.spotify
    pkgs.mpv
    pkgs.ffmpeg

    # tools
    pkgs.localsend
  ]
  ++ (
    if device != "macbook" then
      [
        # media
        pkgs.easyeffects
        pkgs.playerctl
        stable.handbrake

        # tools
        pkgs.wl-clipboard
        pkgs.p7zip
        pkgs.nautilus

        (pkgs.callPackage ./apps/helium.nix { })

        (pkgs.discord.override {
          withVencord = true;
          withOpenASAR = true;
        })
      ]
    else if device == "nixos" then
      [
        pkgs.gradle_9
        pkgs.jdk25
        pkgs.idea
      ]
    else if device == "macbook" then
      [
        pkgs.vesktop

        pkgs.gradle_9
        pkgs.jdk25
        pkgs.jetbrains.idea
        pkgs.prismlauncher
      ]
    else
      [ ]
  );
}
