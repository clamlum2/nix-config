{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.kdePackages.breeze
    pkgs.adwaita-icon-theme
  ];

  home.pointerCursor = {
    name = "breeze_cursors";
    package = pkgs.kdePackages.breeze;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  fonts.fontconfig.enable = true;

  fonts.fontconfig.defaultFonts = {
    monospace = [ "NotoSans Nerd Font Mono" "Noto Sans Mono" ];
    sansSerif = [ "NotoSans Nerd Font" "Noto Sans" ];
    serif = [ "NotoSerif Nerd Font" "Noto Serif" ];
  };

  gtk.iconTheme = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
}
