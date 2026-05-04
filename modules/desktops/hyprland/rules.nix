{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "suppress_event maximize, match:class .*"
      "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"
    ];

    layerrule = [
      "no_anim on, match:namespace launcher"
      "no_anim on, match:namespace quickshell"
    ];
  };
}
