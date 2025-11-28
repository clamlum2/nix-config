{ config, pkgs, ... }:

{
  networking.hostName = "laptop";

  environment.systemPackages = [
    pkgs.linuxKernel.packages.linux_6_12.broadcom_sta
    pkgs.upower
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.kernelModules = [ "wl" ];
  boot.blacklistedKernelModules = [ "b43" "ssb" "bcma" "brcm80211" "brcmfmac" "brcmsmac" "bcmdhd" ];
  nixpkgs.config.permittedInsecurePackages = [

  ];

  programs.nix-ld.enable = true;

  services.upower.enable = true;
}