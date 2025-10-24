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
    "broadcom-sta-6.30.223.271-57-6.12.50"
    "broadcom-sta-6.30.223.271-57-6.12.51"
    "broadcom-sta-6.30.223.271-57-6.12.52"
    "broadcom-sta-6.30.223.271-57-6.12.53"
    "broadcom-sta-6.30.223.271-57-6.12.54"
  ];

  programs.nix-ld.enable = true;

  services.upower.enable = true;
}