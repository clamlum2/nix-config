{ pkgs, ... }:

{
  home.packages = [
    pkgs.hyprlock
  ];

  programs.hyprlock = {
    enable = true;
    settings = {
      "$font" = "JetBrains Mono";

      general = {
        hide_cursor = false;
      };

      animations = {
        enabled = true;

        "bezier" = [ "linear, 1, 1, 0, 0" ];

        animation = [
          "fadeIn, 0, 5, linear"
          "fadeOut, 0, 5, linear"
          "inputFieldDots, 1, 2, linear"
        ];
      };

      background = {
        monitor = "";
        path = "~/Pictures/wallpapers/FullSize.png";
        blur_passes = 0;
      };

      input-field = {
        monitor = "";
        size = "20%, 5%";
        outline_thickness = 1;

        inner_color = "rgba(1f2134cc)";
        outer_color = "rgba(6c8affee)";
        check_color = "rgba(595959ee)";
        fail_color = "rgba(ff0000ee)";

        font_color = "rgb(200, 200, 200)";
        fade_on_empty = true;
        rounding = 0;

        font_family = "$font";
        placeholder_text = "Enter Password";
        fail_text = "$PAMFAIL";

        dots_spacing = 0.3;

        position = "0, -20";
        halign = "center";
        valign = "center";
      };
    };
    extraConfig = ''
      # TIME
      label {
          monitor =
          text = $TIME12
          font_size = 90
          font_family = $font

          position = -30, 0
          halign = right
          valign = top
      }

      # DATE
      label {
          monitor =
          text = cmd[update:60000] date +"%A, %d %B %Y" # update every 60 seconds
          font_size = 25
          font_family = $font

          position = -30, -150
          halign = right
          valign = top
      }
    '';
  };
}
