{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.lutris
    pkgs.protonup-qt
    pkgs.prismlauncher
    pkgs.jdk
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}