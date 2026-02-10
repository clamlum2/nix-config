{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  fileSystems."/mnt/Games" = {
    device = "/dev/disk/by-uuid/8f56f8cf-1cd4-4dab-a2fc-37c29f4e6ed5";
    fsType = "ext4";
  };

  nix.settings = {
    "extra-substituters" = [ "https://attic.xuyh0120.win/lantian" ];
    "extra-trusted-public-keys" = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
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

  users.users.clamt.packages = [
    pkgs.davinci-resolve
  ];

  powerManagement.cpuFreqGovernor = "performance";
}
