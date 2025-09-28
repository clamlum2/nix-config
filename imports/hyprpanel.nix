{ config, pkgs, ... }:

{
  home.packages = [ pkgs.hyprpanel ];

  # need to integrate config file into this file
  xdg.configFile."hyprpanel/config.json".source = ./../resources/hyprpanel/config.json;
}
