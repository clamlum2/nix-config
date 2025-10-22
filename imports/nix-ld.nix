{ config, pkgs, ... }:

{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
        libayatana-appindicator
        libdbusmenu
        pango
        harfbuzz
        cairo
        glib
        xorg.libX11
        alsa-lib
        gtk3
        atk
        gdk-pixbuf
        nss
        nspr
        dbus
        cups
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        libgbm
        expat
        xorg.libxcb
        libxkbcommon
        ffmpeg_4
    ];
  };
}