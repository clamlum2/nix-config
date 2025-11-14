{ pkgs , ... }:

{
  services.vicinae = {
    enable = true;
    autoStart = true;
    settings = {
      closeOnFocusLoss = false;
      faviconService = "twenty";
      font = {
        normal = "DejaVu Sans Mono";
        size = 10.5;
      };
      keybinding = "default";
      popToRootOnClose = true;
      rootSearch = {
        searchFiles = false;
      };
      theme = {
        iconTheme = "Breeze";
        name = "custom";
      };
      window = {
        csd = true;
        opacity = 0.95;
        rounding = 10;
      };
    };
  };

  home.file.".local/share/vicinae/themes/custom.toml".text = ''
    [meta]
    name = "Custom"
    description = "Custom"
    variant = "dark" 
    inherits = "vicinae-dark"
    icon = "/etc/nixos/resources/wallpapers/icon.png"

    [colors.core]
    accent = "#57f7fc"
    accent_foreground = "#ffffff"
    background = "#0d1520"
    foreground = "#ffffff"
    secondary_background = "#0d1520"
    border = "#57f7fc"

    [colors.main_window]
    border = "#57f7fc"

    [colors.settings_window]
    border = "#57f7fc"

    [colors.accents]
    blue = "#2f6fed"
    green = "#3a9c61"
    magenta = "#bc8cff"
    orange = "#f0883e"
    red = "#b9543b"
    yellow = "#bfae78"
    cyan = "#18a5b3"
    purple = "#bc8cff"

    [colors.text]
    default = "#ffffff"
    muted = "#dddddd"
    danger = "#b9543b"
    success = "#3a9c61"
    placeholder = "#dddddd"
    selection = { background = "#579599", foreground = "#ffffff" }

    [colors.text.links]
    default = "#2f6fed"
    visited = "#bc8cff"

    [colors.input]
    border = "#57f7fc"
    border_focus = "#2f6fed"
    border_error = "#b9543b"

    [colors.button.primary]
    background = "#1d2530"
    foreground = "#ffffff"
    hover = { background = "#2d3540" }
    focus = { outline = "colors.core.accent" }

    [colors.list.item.hover]
    background = "#1d2530"
    foreground = "#ffffff"

    [colors.list.item.selection]
    background = "#1d2530"
    foreground = "#ffffff"
    secondary_background = "#0d1520"
    secondary_foreground = "#ffffff"

    [colors.grid.item]
    background = "#0d1520"
    hover = { outline = "#579599" }
    selection = { outline = "#57f7fc" }

    [colors.scrollbars]
    background = "#57f7fc"

    [colors.loading]
    bar = "#57f7fc"
    spinner = "#57f7fc"
  '';
}