{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  fonts.fontconfig.defaultFonts = {
    monospace = [ "NotoSans Nerd Font Mono" "Noto Sans Mono" ];
    sansSerif = [ "NotoSans Nerd Font" "Noto Sans" ];
    serif = [ "NotoSerif Nerd Font" "Noto Serif" ];
  };
}