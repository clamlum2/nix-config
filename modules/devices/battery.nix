{ config, pkgs, ... }:

{
  programs.hyprpanel.settings.bar.layouts."*".right = [
    "systray"
    "battery"
    "volume"
    "bluetooth"
    "network"
    "clock"
    "notifications"
  ];
}