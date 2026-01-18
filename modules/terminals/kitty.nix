{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      background = "#1f2134";
      background_opacity = 0.8;

      font_size = 12.0;
      font_family = "JetBrains Mono Nerd Font";

      cursor_shape = "Beam";
      cursor_trail = 1;
    };
  };
}