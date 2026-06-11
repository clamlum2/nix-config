{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop";

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  environment.systemPackages = [
    pkgs.linuxKernel.packages.linux_6_12.broadcom_sta

    pkgs.brightnessctl
    pkgs.btop
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
    kernelModules = [ "wl" ];
    blacklistedKernelModules = [
      "b43"
      "ssb"
      "bcma"
      "brcm80211"
      "brcmfmac"
      "brcmsmac"
      "bcmdhd"
    ];
  };

  nixpkgs.config.allowInsecurePredicate = pkg: builtins.match "broadcom-sta-.*" pkg.name != null;

  services.upower.enable = true;

  hardware.bluetooth.enable = true;

  services.blueman.enable = true;
}
