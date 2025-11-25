{ config, lib, ... }:

let
  existing = if config ? programs && config.programs ? hyprpanel && config.programs.hyprpanel ? settings && config.programs.hyprpanel.settings ? bar && config.programs.hyprpanel.settings.bar ? layouts && config.programs.hyprpanel.settings.bar.layouts ? "*" && config.programs.hyprpanel.settings.bar.layouts."*" ? right
    then config.programs.hyprpanel.settings.bar.layouts."*".right
    else [];

  hasSystray = builtins.any (x: x == "systray") existing;

  inserted = if hasSystray
    then builtins.concatLists (map (x: if x == "systray" then [ x "battery" ] else [ x ]) existing)
    else builtins.concatLists [ existing [ "battery" ] ];
in

{
  programs.hyprpanel.settings.bar.layouts."*".right = lib.mkForce inserted;
}
