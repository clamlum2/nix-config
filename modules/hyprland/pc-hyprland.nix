{ config, ... }:

{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-1,2560x1440@165,1920x0,1"
      "DP-2,1920x1080@300,0x260,1"
    ];

    workspace = [
      "1, monitor:DP-2, default:true"
      "2, monitor:DP-1,"
      "3, monitor:DP-2,"
      "4, monitor:DP-2,"
      "7, monitor:DP-1,"
      "8, monitor:DP-1,"
    ];

    decoration = {
      screen_shader = "$HOME/.config/hypr/shaders/ev.glsl";
    };
  };
}