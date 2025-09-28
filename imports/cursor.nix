{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.breeze
  ];

  home.pointerCursor = {
    name = "breeze_cursors";
    package = pkgs.kdePackages.breeze;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
