{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.hyprpaper
  ];

  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ~/Pictures/wallpapers/FullSize.png
    wallpaper = DP-1,~/Pictures/wallpapers/FullSize.png
    wallpaper = DP-2,~/Pictures/wallpapers/FullSize.png
    '';
}