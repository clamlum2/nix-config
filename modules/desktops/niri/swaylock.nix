{ pkgs, ... }:

{
  services.logind.settings.Login.HandleLidSwitch = "suspend";

  home-manager.users.clamt = {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        image = "/home/clamt/Pictures/wallpapers/353544.jpg";
        effect-blur = "5x1";

        indicator-radius = 40;
        indicator-thickness = 8;
        indicator-idle-visible = false;
      };
    };

    services.swayidle = {
      enable = true;
      events = {
        lock         = "${pkgs.swaylock-effects}/bin/swaylock -fF";
        before-sleep = "${pkgs.swaylock-effects}/bin/swaylock -fF";
      };
    };
  };
}
