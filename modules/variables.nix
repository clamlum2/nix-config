{ lib, ... }:

{
  options.vars.wallpaperPath = lib.mkOption {
    type = lib.types.str;
    description = "Path to the wallpaper image";
  };

  config.vars.wallpaperPath = "/home/clamt/Pictures/wallpapers/353544.jpg";
}
