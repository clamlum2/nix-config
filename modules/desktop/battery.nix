{ config, pkgs, lib, ... }:

{
  programs.hyprpanel.settings.bar.layouts."*".right = [ "battery" ];
}
