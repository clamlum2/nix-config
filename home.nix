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
    # apps
    ./modules/apps/hyprlauncher.nix
    ./modules/apps/vicinae.nix
    ./modules/apps/wofi.nix

    # desktop
    ./modules/desktop/hyprland.nix
    ./modules/desktop/hyprlock.nix
    ./modules/desktop/hyprpanel.nix
    ./modules/desktop/hyprshade.nix
    ./modules/desktop/kvantum.nix
    ./modules/desktop/theme.nix

    # shell
    ./modules/shell/btop.nix
    ./modules/shell/ssh.nix
    ./modules/shell/zsh.nix

    # terminals
    ./modules/terminals/ghostty.nix
    ./modules/terminals/wezterm.nix
  ];
}
