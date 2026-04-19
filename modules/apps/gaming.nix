{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.lutris
    pkgs.protonup-qt
    pkgs.prismlauncher
    pkgs.jdk25
    pkgs.mangohud
    # pkgs.steamtinkerlaunch
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    # protontricks.enable = true;
  };
}