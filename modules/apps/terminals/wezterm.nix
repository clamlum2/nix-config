{ ... }:

{
  programs.wezterm.enable = true;

  home.file.".wezterm.lua".source = ../../../resources/wezterm/wezterm.lua;
}
