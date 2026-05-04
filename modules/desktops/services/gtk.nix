{ pkgs, ... }:

{
  programs.dconf.enable = true;

  environment.systemPackages = [
    pkgs.glib
    pkgs.gsettings-desktop-schemas
    pkgs.gnome-themes-extra
    pkgs.adwaita-icon-theme
  ];
}
