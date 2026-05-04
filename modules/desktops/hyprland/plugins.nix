{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    plugins = [
      pkgs.hyprlandPlugins.hyprscrolling
      pkgs.hyprlandPlugins.hyprexpo
    ];
    settings = {
      general = {
        layout = "scrolling";
      };

      # exec-once = [
      #   "hyprctl plugin load ${pkgs.hyprlandPlugins.hyprscrolling}/lib/libhyprscrolling.so"
      # ];

      plugin = {
        hyprscrolling = {
          column_width = 0.5;
          fullscreen_on_one_column = true;
        };

        hyprexpo = {
          columns = 2;
          gap_size = 0;
          workspace_method = "first 1";
        };
      };
    };
  };
}
