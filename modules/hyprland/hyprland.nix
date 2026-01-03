{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.hyprshade
  ];

  imports = [
    ./visuals.nix
    ./binds.nix
    ./startup.nix
    ./rules.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      general = {
        allow_tearing = true;
        layout = "dwindle";
        resize_on_border = false;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      input = {
        kb_layout = "us";
        kb_options = "caps:none";

        follow_mouse = 1;

        sensitivity = 0;
      };
    };
  };

  home.file.".config/hypr/shaders/ev.glsl".source = ../../resources/hyprland/ev.glsl;
}
