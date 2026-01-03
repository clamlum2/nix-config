{ config, ... }:

{
  wayland.windowManager.hyprland.settings = {
    env = [ ];

    exec-once = [
      "hyprctl setcursor Breeze 24"
      "qs"
      "wezterm"
      "easyeffects --gapplication-service"
      "hyprpaper"
    ];
  };
}
