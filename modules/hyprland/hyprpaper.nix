{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.hyprpaper
  ];

  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ~/Pictures/wallpapers/FullSize.png
    splash = false

    wallpaper {
      monitor = DP-1
      path = ~/Pictures/wallpapers/FullSize.png
      fit_mode = fill
    }

    wallpaper {
      monitor = DP-2
      path = ~/Pictures/wallpapers/FullSize.png
      fit_mode = fill
    }

    wallpaper {
      monitor = eDP-1
      path = ~/Pictures/wallpapers/FullSize.png
      fit_mode = fill
    }
  '';
}