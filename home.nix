{ config, pkgs, lib, ... }:

{

  home.username = "clamt";
  home.homeDirectory = "/home/clamt";
  home.stateVersion = "25.05";

  # Import the Zsh config
  imports = [ 
    ./imports/device-home.nix

    ./imports/zsh.nix
    ./imports/kitty.nix
    ./imports/hyprland.nix
    ./imports/cursor.nix
    ./imports/kvantum.nix
    ./imports/wofi.nix
    ./imports/hyprlock.nix
    ./imports/ssh.nix

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
