{ pkgs, nixpkgs-stable, ... }:

let
  stable = import nixpkgs-stable {
    system = pkgs.system or "x86_64-linux";
    config.allowUnfree = true;
  };
in

{
  environment.systemPackages = [
    stable.lutris
    pkgs.protonup-qt
    pkgs.prismlauncher
    pkgs.jdk25
    pkgs.mangohud
    # pkgs.steamtinkerlaunch
    stable.wineWowPackages.stable
    pkgs.winetricks
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;
  };
}
