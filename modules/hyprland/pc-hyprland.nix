{ config, ... }:

{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-1,2560x1440@165,1920x0,1"
      "DP-2,1920x1080@300,0x260,1"
    ];

    workspace = [
      "1, monitor:DP-2, persistent:true, default:true"
      "2, monitor:DP-1, persistent:true"
      "7, monitor:DP-1, persistent:true"
      "8, monitor:DP-1, persistent:true"
    ];
  };
}