{ config, pkgs, ... }:

{  
  networking.hostName = "laptop";

  environment.systemPackages = with pkgs; [
    pkgs.linuxKernel.packages.linux_zen.broadcom_sta
    pkgs.upower
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.kernelModules = [ "wl" ];
  boot.blacklistedKernelModules = [ "b43" "ssb" "bcma" "brcm80211" "brcmfmac" "brcmsmac" "bcmdhd" ];
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-57-6.16.7"
    "broadcom-sta-6.30.223.271-57-6.16.5"
  ];

  programs.nix-ld.enable = true;

  services.upower.enable = true;
}