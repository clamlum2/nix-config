{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    env = [
      "XCURSOR_SIZE,24"
      "XCURSOR_THEME,Breeze"
      "EDITOR,micro"
    ];

    exec-once = [
      "hyprctl setcursor Breeze 24"
      "qs"
      "easyeffects --gapplication-service"
      "hyprpaper"
      "openrgb --startminimized -p blue"
    ];
  };
}
