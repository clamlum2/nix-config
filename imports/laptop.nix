{ config, pkgs, ... }:

{  
  networking.hostName = "laptop";

  environment.systemPackages = [
    pkgs.linuxKernel.packages.linux_6_12.broadcom_sta
    pkgs.upower
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.kernelModules = [ "wl" ];
  boot.blacklistedKernelModules = [ "b43" "ssb" "bcma" "brcm80211" "brcmfmac" "brcmsmac" "bcmdhd" ];
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.12.57"
  ];

  programs.nix-ld.enable = true;

  services.upower.enable = true;
}