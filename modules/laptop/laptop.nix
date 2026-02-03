{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostname = "laptop";

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
}