{ config, pkgs, ... }:

{
  programs.nix-ld = {
    enable = true;
    libraries =  [
        pkgs.libayatana-appindicator
        pkgs.libdbusmenu
        pkgs.pango
        pkgs.harfbuzz
        pkgs.cairo
        pkgs.glib
        pkgs.xorg.libX11
        pkgs.alsa-lib
        pkgs.gtk3
        pkgs.atk
        pkgs.gdk-pixbuf
        pkgs.nss
        pkgs.nspr
        pkgs.dbus
        pkgs.cups
        pkgs.xorg.libXcomposite
        pkgs.xorg.libXdamage
        pkgs.xorg.libXext
        pkgs.xorg.libXfixes
        pkgs.xorg.libXrandr
        pkgs.libgbm
        pkgs.expat
        pkgs.xorg.libxcb
        pkgs.libxkbcommon
        pkgs.ffmpeg_4
    ];
  };
}