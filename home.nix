{ config, pkgs, lib, nixpkgs-unstable, ... }:

let
  unstable = import nixpkgs-unstable {
    system = pkgs.system or "x86_64-linux";
    config.allowUnfree = true;
  };
in

{

  home.username = "clamt";
  home.homeDirectory = "/home/clamt";
  home.stateVersion = "25.05";

  # Import the Zsh config
  imports = [
    ./imports/zsh.nix
    ./imports/wezterm.nix
    ./imports/hyprland.nix
    ./imports/cursor.nix
    ./imports/kvantum.nix
    ./imports/wofi.nix
    ./imports/hyprlock.nix
    ./imports/ssh.nix
    ./imports/ghostty.nix
    ./imports/hyprpanel.nix
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

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  xdg.desktopEntries = {
    vesktop = {
      name = "Vesktop";
      exec = "vesktop --ozone-platform=wayland";
      icon = "vesktop";
      type = "Application";
      categories = [ "Network" "InstantMessaging" "Chat" ];
      terminal = false;
    };
  };
}
