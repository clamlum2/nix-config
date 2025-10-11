{ config, pkgs, lib, ... }:

{

  home.username = "clamt";
  home.homeDirectory = "/home/clamt";
  home.stateVersion = "25.05";

  # Import the Zsh config
  imports = [ 
    ./imports/hyprpanel-pc.nix
    ./imports/hyprshade.nix

    ./imports/zsh.nix
    ./imports/wezterm.nix
    ./imports/hyprland.nix
    ./imports/cursor.nix
    ./imports/kvantum.nix
    ./imports/wofi.nix
    ./imports/hyprlock.nix
    ./imports/ssh.nix
    ./imports/ghostty.nix

    # need to add proper fastfetch config
  ];

  fonts.fontconfig.enable = true;

  fonts.fontconfig.defaultFonts = {
    monospace = [ "NotoSans Nerd Font Mono" "Noto Sans Mono" ];
    sansSerif = [ "NotoSans Nerd Font" "Noto Sans" ];
    serif = [ "NotoSerif Nerd Font" "Noto Serif" ];
  };

  home.packages = [
    pkgs.adwaita-icon-theme
  ];

  gtk.iconTheme = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
  };
}
