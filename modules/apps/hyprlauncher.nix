{ config, ... }:

{
  home.file.".config/hypr/hyprtoolkit.conf".text = ''
    background = rgba(0d1520cc)
    base = rgba(0d1520cc)
    text = rgb(ffffff)
    alternate_base = rgba(0d1520cc)
    bright_text = rgb(57f7fc)
    accent = rgb(57f7fc)
    accent_secondary = rgb(579599)
    font_family = "DejaVuSansM Nerd Font Mono"
    font_family_monospace = "DejaVuSansM Nerd Font Mono"
    desktop_icons = false
  '';
}