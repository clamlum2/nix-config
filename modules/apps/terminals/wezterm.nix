{ repoRoot, ... }:

{
  programs.wezterm.enable = true;

  home.file.".wezterm.lua".source = "${repoRoot}/resources/wezterm/wezterm.lua";
}
