{ config, pkgs, nixpkgs-unstable, ... }:

{
  networking.hostName = "nixos";

  environment.systemPackages = [
    pkgs.protonup-qt
    pkgs.lutris
    pkgs.wine
    pkgs.wine64
    pkgs.prismlauncher
    pkgs.niv
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  services.samba = {
    enable = true;
    settings = {
      share = {
        path = "/home/clamt/share";
        browseable = true;
        "read only" = false;
        "guest ok" = false;
        "valid users" = "clamt";
      };
    };
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  fileSystems."/home/clamt/Games" = {
    device = "/dev/disk/by-uuid/44B26CAFB26CA760";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" "gid=1000" "umask=0022" ];
  };
}