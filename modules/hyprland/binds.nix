{ config, ... }:

{
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    "$browser" = "helium-browser";
    "$fileManager" = "ghostty -e yazi";
    "$menu" = "fuzzel";
    "$terminal" = "ghostty";

    bind = [
      "$mainMod, Q, killactive"
      "$mainMod, M, exit"
      "$mainMod, R, pseudo"
      "$mainMod, B, togglesplit"
      "$mainMod, N, togglefloating"
      "$mainMod, F, fullscreen"
      "$mainMod, L, exec, hyprlock"

      "$mainMod, T, exec, $terminal"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, SPACE, exec, pkill $menu || $menu"
      "$mainMod, D, exec, $browser"
      "$mainMod SHIFT, D, exec, vesktop"

      "$mainMod, TAB, exec, sh $HOME/.config/quickshell/position.sh"
      ", KP_SUBTRACT, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

      "$mainMod, C, sendshortcut, CTRL, Insert,"
      "$mainMod, V, sendshortcut, SHIFT, Insert,"

      "$mainMod ALT, SPACE, exec, vicinae toggle"
      "$mainMod ALT, V, exec, vicinae vicinae://extensions/vicinae/clipboard/history"

      "$mainMod, S, exec, hyprshade off || true && grim -o $(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .name') - | wl-copy && hyprctl reload"
      "$mainMod SHIFT, S, exec, hyprshade off || true && grim -g \"$(slurp -d)\" - | wl-copy && hyprctl reload"

      "$mainMod CTRL, LEFT, exec, playerctl previous"
      "$mainMod CTRL, RIGHT, exec, playerctl next"
      "$mainMod CTRL, SPACE, exec, playerctl play-pause"

      "$mainMod SHIFT, N, exec, ~/.config/hypr/floating.sh"

      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
    ];

    binde = [
      "$mainMod CTRL, UP, exec, playerctl volume 0.05%+"
      "$mainMod CTRL, DOWN, exec, playerctl volume 0.05%-"
    ];

    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    bindel = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ", XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
      ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
    ];

    bindl = [
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"

      ", switch:Lid Switch, exec, hyprlock"
    ];
  };
}