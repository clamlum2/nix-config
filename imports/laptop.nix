{ config, pkgs, ... }:

{  
  networking.hostName = "laptop";

  environment.systemPackages = with pkgs; [
    pkgs.linuxKernel.packages.linux_6_16.broadcom_sta
    pkgs.upower
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.kernelModules = [ "wl" ];
  boot.blacklistedKernelModules = [ "b43" "ssb" "bcma" "brcm80211" "brcmfmac" "brcmsmac" "bcmdhd" ];
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-57-6.16.7"
    "broadcom-sta-6.30.223.271-57-6.16.9"
  ];

  programs.nix-ld.enable = true;

  services.upower.enable = true;
}