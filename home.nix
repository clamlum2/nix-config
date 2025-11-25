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

  imports = [
    # apps
    ./modules/apps/hyprlauncher.nix
    ./modules/apps/wofi.nix

    # desktop
    ./modules/desktop/fonts.nix
    ./modules/desktop/hyprland.nix
    ./modules/desktop/hyprlock.nix
    ./modules/desktop/hyprpanel.nix
    ./modules/desktop/hyprshade.nix
    ./modules/desktop/icons.nix
    ./modules/desktop/kvantum.nix

    # shell
    ./modules/shell/btop.nix
    ./modules/shell/zsh.nix

    # terminals
    ./modules/terminals/ghostty.nix
    ./modules/terminals/wezterm.nix
  ];
}
