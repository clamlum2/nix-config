{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  fileSystems."/mnt/Games" = {
    device = "/dev/disk/by-uuid/44B26CAFB26CA760";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" "gid=1000" "umask=0022" ];
  };

  nix.settings = {
    substituters = [
      "https://attic.xuyh0120.win/lantian"
    ];

    trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 25565 ];
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  services.hardware.openrgb.enable = true;
}
