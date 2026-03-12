{ config, ... }:

{
  wayland.windowManager.hyprland.settings = {
    general = {
      border_size = 1;

      "col.active_border" = "rgba(6c8affee)";
      "col.inactive_border" = "rgba(595959ee)";

      gaps_in = 0;
      gaps_out = 0;
    };

    decoration = {
      blur = {
        enabled = true;
        passes = 1;
        size = 3;
        vibrancy = 0.169600;
      };

      shadow = {
        enabled = false;
      };

      active_opacity = 1.0;
      inactive_opacity = 1.0;

      rounding = 0;
      rounding_power = 2;
    };

    animations = {
      enabled = true;

      bezier = [
        "easeOutQuint,0.23,1,0.32,1"
        "easeInOutCubic,0.65,0.05,0.36,1"
        "linear,0,0,1,1"
        "almostLinear,0.5,0.5,0.75,1.0"
        "quick,0.15,0,0.1,1"
      ];

      animation = [
        "global, 1, 1, default"
        "border, 1, 1, easeOutQuint"
        "windows, 1, 3, easeOutQuint"
        "windowsIn, 1, 1, easeOutQuint, popin 87%"
        "windowsOut, 1, 1, linear, popin 87%"
        "fadeIn, 1, 1.73, almostLinear"
        "fadeOut, 1, 1.46, almostLinear"
        "fade, 1, 3.03, quick"
        "layers, 1, 3.81, easeOutQuint"
        "layersIn, 1, 4, easeOutQuint, fade"
        "layersOut, 1, 1.5, linear, fade"
        "fadeLayersIn, 1, 1.79, almostLinear"
        "fadeLayersOut, 1, 1.39, almostLinear"
        "workspaces, 0, 1.94, almostLinear, fade"
        "workspacesIn, 0, 1.21, almostLinear, fade"
        "workspacesOut, 0, 1.94, almostLinear, fade"
      ];
    };

    misc = {
      force_default_wallpaper = -1;
      disable_hyprland_logo = true;
    };
  };
}
