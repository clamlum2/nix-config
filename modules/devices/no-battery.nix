{ config, pkgs, ... }:

{
  programs.hyprpanel.settings.bar.layouts."*".right = [
    "systray"
    "volume"
    "bluetooth"
    "network"
    "clock"
    "notifications"
  ];
}