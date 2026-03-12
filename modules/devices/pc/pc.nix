{ config, pkgs, nixpkgs-stable, ... }:

let
  stable = import nixpkgs-stable {
    system = pkgs.system or "x86_64-linux";
    config.allowUnfree = true;
  };
in

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  fileSystems."/mnt/Games" = {
    device = "/dev/disk/by-uuid/8f56f8cf-1cd4-4dab-a2fc-37c29f4e6ed5";
    fsType = "ext4";
  };

  # fileSystems."/mnt/VMs" = {
  #   device = "/dev/disk/by-uuid/9a0cfacd-022f-4991-9bdb-8f048c66c143";
  #   fsType = "ext4";
  # };

  # nix.settings = {
  #   "extra-substituters" = [ "https://attic.xuyh0120.win/lantian" ];
  #   "extra-trusted-public-keys" = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
  # };

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
    package = stable.sunshine;
  };

  # programs.hyprland = {
  #   enable = true;
  #   withUWSM = true;
  #   xwayland.enable = true;
  # };

  services.hardware.openrgb.enable = true;

  powerManagement.cpuFreqGovernor = "performance";
}
