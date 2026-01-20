{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    settings = {
      background = "#1f2134";
      background-opacity = 0.8;
      # font-family = "DejaVuSansM Nerd Font Mono";
      font-size = 12;
      theme = "Kitty Default";
      custom-shader-animation = "always";
      custom-shader = "cursor.glsl";
      selection-foreground = "cell-background";
      selection-background = "cell-foreground";
      selection-clear-on-typing = true;
      cursor-color = "#ffffff";
      foreground = "#ffffff";
      cursor-click-to-move = true;
      focus-follows-mouse = true;

      shell-integration-features = [
        "ssh-env"
      ];

      keybind = [
        "alt+arrow_down=goto_split:down"
        "alt+arrow_up=goto_split:up"
        "alt+arrow_left=goto_split:left"
        "alt+arrow_right=goto_split:right"

        "ctrl+alt+arrow_down=new_split:down"
        "ctrl+alt+arrow_up=new_split:up"
        "ctrl+alt+arrow_left=new_split:left"
        "ctrl+alt+arrow_right=new_split:right"
      ];
    };
  };

  home.file.".config/ghostty/cursor.glsl".source = ../../resources/ghostty/cursor.glsl;
}