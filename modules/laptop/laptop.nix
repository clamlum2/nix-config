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
}