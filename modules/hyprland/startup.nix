{ config, ... }:

{
  wayland.windowManager.hyprland.settings = {
    env = [
      "XCURSOR_SIZE,24"
      "XCURSOR_THEME,Breeze"
    ];

    exec-once = [
      "hyprctl setcursor Breeze 24"
      "qs"
      "wezterm"
      "easyeffects --gapplication-service"
      "hyprpaper"
    ];
  };
}
